

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

Multipass can be installed with the following command on any [snap-enabled linux](https://snapcraft.io):

```
sudo snap install multipass --beta --classic
```

### Start an Ubuntu Virtual Machine

##### Start your Multipass VM

You can mount a local volume into the VM. The second command mounts your the local `kubeflow-demo` directory in the virtual machine at `/multipass`.

```
multipass launch bionic -n kubeflow -m 8G -d 40G -c 4 --cloud-init kubeflow.init && \
multipass mount . kubeflow:/multipass
```

**Note**: These are the minimum recommended settings on the VM created by Multipass for the Kubeflow deployment. You are free to adjust them **higher** based on your host machine capabilities and workload requirements.


#### Configure secret.env

Create or use an existing (Github token)[https://github.com/settings/tokens].

`touch secret.env`
`echo "export GITHUB_TOKEN=<your Github token>" > secret.env`

### Install Kubernetes
Log into the VM and install some basic supporting tools. This will install kubernetes, powered by microk8s, and other tools necessary to deploy Kubeflow

```
multipass shell kubeflow                      # log into vm
source /multipass/secret.env # set GITHUB_TOKEN environment variable in vm shell
sudo /multipass/install.sh  # install microk8s, kubeflow etc.
```

### Cleaning up

When you're done with this demo, delete & purge the VM you created.

`multipass delete kubeflow && multipass purge`