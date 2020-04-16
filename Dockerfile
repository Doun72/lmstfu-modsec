FROM owasp/modsecurity
LABEL maintainer="Didier Hunacek <didier.hunacek@nagra.com>"
ARG COMMIT=v3.3/dev
ARG BRANCH=v3.3/dev
ARG VER=3.3
ARG REPO=SpiderLabs/owasp-modsecurity-crs
ENV WEBSERVER=Nginx
## Level1 = basic security ; level2 = elevated security; level3 = online banking security; level4 = nuclear power plant security
ENV PARANOIA=3 
ENV ANOMALYIN=5
ENV ANOMALYOUT=4

RUN apt-get update && \
  apt-get -y install python git ca-certificates iproute2  curl && \
  mkdir /opt/owasp-modsecurity-crs-${VER} && \
  cd /opt/owasp-modsecurity-crs-${VER} && \
  git init && \
  git remote add origin https://github.com/${REPO} && \
  git fetch --depth 1 origin ${BRANCH} && \
  git checkout ${COMMIT} && \
  mv crs-setup.conf.example crs-setup.conf && \
  ln -sv /opt/owasp-modsecurity-crs-${VER} /etc/modsecurity.d/owasp-crs && \
  printf "include /etc/modsecurity.d/owasp-crs/crs-setup.conf\ninclude /etc/modsecurity.d/owasp-crs/rules/*.conf" >> /etc/modsecurity.d/include.conf && \
  sed -i -e 's/SecRuleEngine DetectionOnly/SecRuleEngine On/g' /etc/modsecurity.d/modsecurity.conf


##COPY ./keys/ /etc/httpd/keys/
##COPY ./crs/ /etc/httpd/crs/
##COPY ./modsecurity.d/ /etc/modsecurity.d/
##COPY ./conf/ /etc/httpd/conf/
COPY ./modsecurity/crs-nginx/ /etc/modsecurity.d/owasp-crs/rules/
##COPY ./conf.d/ /etc/httpd/conf.d/
##COPY ./conf.d/reverse-proxy.conf /etc/nginx/conf.d/sites-available/reverse-proxy.conf

COPY ./conf/nginx.conf /etc/nginx/
COPY ./conf.d/default.conf /etc/nginx/conf.d

CMD ["/bin/bash", "-c", "exec nginx -g 'daemon off;';"]
WORKDIR /etc