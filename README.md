# jcasc

![Jenkins](https://img.shields.io/badge/-jenkins-D24939?style=for-the-badge&logo=Jenkins&logoColor=white)
![Kustomize](https://img.shields.io/badge/-kustomize-326CE5?style=for-the-badge&logo=Kubernetes&logoColor=white)

The purpose is to locally spin up a pre-configured Jenkins instance that uses [`Jenkins Kubernetes Plugin`](https://plugins.jenkins.io/kubernetes/) to dynamically create containers on specific namespaces for CI builds.

### Using the project
```bash
git clone https://github.com/theJaxon/jcasc.git

cd jcasc
docker build -t jenkins-local .

cd Deployment 

# Apply resources inside Deployment directory via Kustomize 
kustomize build . | kubectl apply -f -

# Login username and password are admin
```

---

### Setup
#### Dockerfile configuration

- Dockerfile is used to handle the installation of all the required Plugins.

```bash
# Create new image with plugins specified in Dockerfile pre-installed
docker build -t jenkins-local .
```

---

#### Integration with Kubernetes 
- The current cluster setup is the same as [`Kontainterd project setup`](https://github.com/theJaxon/Kontainerd)
- To give Jenkins access to Spin up pods in any namespace there's a service account created, this SA gets tied to the cluster role `cluster-admin`
- All this is handled via `kustomization.yaml`
- Kustomize generates a configMap from `JCasC.yaml` file then the file gets mounted at `/var/jenkins_home/casc_configs/JCasC.yaml`
- Configuration as code file is loaded via the environment variable `CASC_JENKINS_CONFIG`
- Deployment strategy is `recreate` instead of `RollingUpdate` , while it's not best practice this avoids having 2 jenkins pods at the same time as this setup is done locally so resources are limited, under normal circumstances however the strategy part should be removed from Deployemnt as `RollingUpdate` is used by default.


---

#### Jenkins Kubernetes cloud configuration
- The connection between dynamic pods and jenkins is handled via [`jnlp-slave`](https://hub.docker.com/r/jenkinsci/jnlp-slave/)
- For this a Pod template is created where the container name is **jnlp**, when the name changed it caused errors so it's kept as jnlp and the Pod template name is also **jnlp**
- The template is pre-configured via jcasc
