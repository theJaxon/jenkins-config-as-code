# jenkins-config-as-code 

![Jenkins](https://img.shields.io/badge/-jenkins-D24939?style=for-the-badge&logo=Jenkins&logoColor=white)
![Kustomize](https://img.shields.io/badge/-kustomize-326CE5?style=for-the-badge&logo=Kubernetes&logoColor=white)

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Using the project](#using-the-project)
  - [Integration with Kubernetes](#integration-with-kubernetes)
  - [Jenkins Kubernetes cloud configuration](#jenkins-kubernetes-cloud-configuration)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

The purpose is to locally spin up a pre-configured Jenkins instance that uses [`Jenkins Kubernetes Plugin`](https://plugins.jenkins.io/kubernetes/) to dynamically create containers on specific namespaces for CI builds.

### Using the project
- Dockerfile is used to handle the installation of all the required Plugins.
- Instructions below are for building on [Kontainer8](https://github.com/theJaxon/Kontainer8) Worker node

```bash
git clone https://github.com/theJaxon/jenkins-config-as-code.git

cd jenkins-config-as-code

# Create new image with plugins specified in Dockerfile pre-installed
podman build --tag jenkins-local .

# Save the image into tar file
podman save jenkins-local -o jenkins-local.tar

# Use ctr to import the image 
sudo ctr -n=k8s.io images import jenkins-local.tar

# Apply resources inside Deployment directory via Kustomize 
kustomize build Manifests | kubectl apply -f -

# Login username and password are admin
```

---

#### Integration with Kubernetes 
- The current cluster setup is the same as [`Kontainter8 project setup`](https://github.com/theJaxon/Kontainer8)
- To give Jenkins access to Spin up pods in any namespace there's a [service account](https://github.com/theJaxon/jcasc/blob/main/Deployment/service-account.yaml) created, this SA gets tied to the cluster role [`cluster-admin`](https://github.com/theJaxon/jcasc/blob/main/Deployment/cluster-role-binding.yaml)
- All this is handled via [`kustomization.yaml`](https://github.com/theJaxon/jcasc/blob/main/Deployment/kustomization.yaml)
- Kustomize [generates a configMap](https://github.com/theJaxon/jcasc/blob/main/Deployment/kustomization.yaml#L20) from `JCasC.yaml` file then the file gets mounted at `/var/jenkins_home/casc_configs/JCasC.yaml`
- Configuration as code file is loaded via the environment variable [`CASC_JENKINS_CONFIG`](https://github.com/theJaxon/jenkins-config-as-code/blob/main/Manifests/statefulset.yaml#L41)
- Persistent Volume is created Via local-path provisioner with is the default storage class for Kontainer8

---

#### Jenkins Kubernetes cloud configuration
- The connection between dynamic pods and jenkins is handled via [`jnlp-slave`](https://hub.docker.com/r/jenkinsci/jnlp-slave/)
- For this a Pod template is created where the container name is **jnlp**, when the name changed it caused errors so it's kept as jnlp and the Pod template name is also **jnlp**
- The template is pre-configured via jcasc
