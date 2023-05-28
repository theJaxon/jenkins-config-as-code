FROM docker.io/jenkins/jenkins:lts-jdk11
RUN jenkins-plugin-cli --plugins \
antisamy-markup-formatter \
ant \
build-timeout \
configuration-as-code \
credentials-binding \
cloudbees-folder \
git \
github-branch-source \
gitea \
gradle \
kubernetes \
ldap \
matrix-auth \
 mailer:448.v5b_97805e3767 \
monitoring \
pam-auth \
pipeline-aws \
pipeline-github-lib \
pipeline-stage-view \
timestamper \
workflow-aggregator \
workflow-multibranch \
ws-cleanup
