FROM owasp/modsecurity

RUN dnf -y update && \
  dnf install -y mod_ssl && \
  dnf clean all

COPY ./public-html/ /var/www/html/
COPY ./keys/ /etc/httpd/keys/
COPY ./crs/ /etc/httpd/crs/
COPY ./modsecurity.d/ /etc/httpd/modsecurity.d/
COPY ./conf/ /etc/httpd/conf/
COPY ./modsecurity/ /etc/httpd/modsecurity/
COPY ./conf.d/ /etc/httpd/conf.d/

