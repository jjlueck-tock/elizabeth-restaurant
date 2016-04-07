FROM centos:centos6
MAINTAINER JJ Lueck <jlueck@tockhq.com>

RUN yum install -y epel-release
RUN yum install -y nodejs npm

COPY package.json /srv/package.json
RUN cd /srv; npm install --production

COPY . /srv

EXPOSE 8080
ENTRYPOINT ["node", "/srv/app.js"]
