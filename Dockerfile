FROM           dokken/centos-8
RUN            yum install epel-release -y
COPY           mongo.repo /etc/yum.repos.d/mongo.repo
RUN            yum install unzip git mysql mongodb-org-shell -y
RUN           curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install
COPY           run.sh /
ENTRYPOINT     [ "bash", "/run.sh" ]





#epel contails lot of packeage including devops with ansible
