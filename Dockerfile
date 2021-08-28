FROM jenkins/jenkins:lts-jdk11
RUN jenkins-plugin-cli --plugins \
configuration-as-code \
git \
gitea \
kubernetes \
monitoring \
pipeline-aws \
workflow-aggregator \ 
workflow-multibranch 
