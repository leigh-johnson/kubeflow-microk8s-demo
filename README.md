

# Kubeflow Demo via MicroK8s

```
git clone git@github.com/leigh-johnson/kubeflow-microk8s-demo.git
cd kubeflow-microk8s-demo
```

### What is Kubeflow?

The Kubeflow project is dedicated to making deployments of machine learning (ML) workflows on Kubernetes simple, portable and scalable. Read more [About Kubeflow](https://www.kubeflow.org/docs/about/kubeflow/)

This demo will focus on getting started locally with MicroK8s, using Multipass. [Source: Getting Started](https://www.kubeflow.org/docs/started/getting-started-multipass/)

### Additional Concepts

* [What is Kubernetes?](https://kubernetes.io/docs/concepts/overview/what-is-kubernetes/)
* [What is Multipass?](https://github.com/CanonicalLtd/multipass)
* [What is Microk8s?](https://microk8s.io/)


### Install Multipass

If you do not already have multipass installed, follow the directions below.

##### Mac OS X
Install Multipass using the native Mac OS [installer](https://github.com/CanonicalLtd/multipass/releases/download/2018.6.1/multipass-2018.6.1-full-Darwin-signed.zip).

##### Linux

Multipass can be installed with the following command on any [snap-enabled linux distribution](https://snapcraft.io):

```
sudo snap install multipass --beta --classic
```

### Start an Ubuntu Virtual Machine

##### Start your Multipass VM

You can mount a local volume into the VM. The second command mounts your the local `kubeflow-demo` directory in the virtual machine at `/multipass`.

```
multipass launch bionic -n kubeflow -m 8G -d 40G -c 4 --cloud-init kubeflow.init && \
multipass mount . kubeflow:/home/multipass/demo
multipass mount ${PWD}/my-app kubeflow:/home/multipass/my-app
```

**Note**: These are the minimum recommended settings on the VM created by Multipass for the Kubeflow deployment. You are free to adjust them **higher** based on your host machine capabilities and workload requirements.


### Configure secret.env

Create or use an existing (Github token)[https://github.com/settings/tokens].

`touch secret.env`
`echo "export GITHUB_TOKEN=<paste your Github token>" > secret.env`

### Install Kubernetes

Log into the VM and install some basic supporting tools. This will install kubernetes via microk8s, make, ksonnet, and kubeflow.

##### Configure your app (optional)

Set the following environment variables before running `install.sh` to configure your setup. If you choose not to provide them, the defaults below will be used.

```
export NAMESPACE=default # kubernetes namespace
export APP_NAME=my-app
export APP_DIR=/home/multipass/demo/my-app
export KUBEFLOW_TAG=v0.3.3
export KUBEFLOW_SRC=/home/multimass/kubeflow
```

```
multipass shell kubeflow                      # log into vm
source /home/multipass/demo/secret.env # set GITHUB_TOKEN environment variable in vm shell
./demo/install.sh  # install microk8s, kubeflow etc.
```

### Cleaning up

When you're done with this demo, delete & purge the VM you created.

`multipass delete kubeflow && multipass purge`