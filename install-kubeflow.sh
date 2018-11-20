#!/usr/bin/env bash

error() {
    printf '\E[31m'; echo "$@"; printf '\E[0m'
}

if [[ -z "${GITHUB_TOKEN}" ]]; then
    error "The GITHUB_TOKEN environment variable isn't set."
    error "Please visit https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/"
    exit 1
fi

set -e  # exit immediately on error
set -u  # fail on undeclared variables

# Create a namespace for kubeflow deployment
NAMESPACE=${NAMESPACE:-kubeflow}
kubectl create namespace ${NAMESPACE}

# Which version of Kubeflow to use
# For a list of releases refer to:
# https://github.com/kubeflow/kubeflow/releases
KUBEFLOW_TAG=${KUBEFLOW_TAG:-v0.3.3}

KUBEFLOW_SRC=${KUBEFLOW_SRC:-/home/multipass/kubeflow}
APP_NAME=${APP_NAME:-my-app}
APP_DIR=${APP:-/home/multipass/demo/my-app}

mkdir -p ${KUBEFLOW_SRC}

cd $KUBEFLOW_SRC
curl https://raw.githubusercontent.com/kubeflow/kubeflow/${KUBEFLOW_TAG}/scripts/download.sh | bash
cd ../

${KUBEFLOW_SRC}/scripts/kfctl.sh init ${APP_NAME} --platform none
cd ${APP_DIR}
${KUBEFLOW_SRC}/scripts/kfctl.sh generate k8s
cd ks_app
# For non-cloud use .. use NodePort (instead of ClusterIp)
ks param set jupyterhub ServiceType NodePort
# https://github.com/kubeflow/kubeflow/issues/1367
# use pip packaging for jupyterhub
ks param set jupyterhub image leighjohnson/jupyterhub:latest
cd ../
${KUBEFLOW_SRC}/scripts/kfctl.sh apply k8s

until [[ `kubectl get pods -n=kubeflow | grep -o 'ContainerCreating' | wc -l` == 0 ]] ; do 
  echo "Checking kubeflow status until all pods are running ("`kubectl get pods -n=kubeflow | grep -o 'ContainerCreating' | wc -l`" not running). Sleeping for 10 seconds."
  sleep 10
done

# Print port information
PORT=`kubectl get svc -n=kubeflow -o go-template='{{range .items}}{{if eq .metadata.name "tf-hub-lb"}}{{(index .spec.ports 0).nodePort}}{{"\n"}}{{end}}{{end}}'`
echo ""
echo "JupyterHub Port: ${PORT}"
echo ""