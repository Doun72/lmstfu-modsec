# lmstfu-modsec

An Apache ModSecurity with Core Rule Set example of virtual patching, lmstfu.com style

See [lmstfu.com](https://lmstfu.com) for details.

This is a fairly vanilla Apache httpd configuration, with the addition
of modsecurity and the core rule set. The project-specific stuff is in
the modsecurity folder, which is where all the virtual patches live.

To get this running, the easiest way is to spin up docker:

`docker run --name lmstfu-modsec -p 80:80 -p 443:443 -it --rm
--network mstfu lmstfu-modsec`

You'll need to have an 'lmstfu' network created already in docker:

`docker network create lmstfu`

If you want to spin it up at the same time as lmstfu-node, you could
try this simple docker-compose.yml file:


```
version: '3'
services:
  lmstfu-node:
    image: lmstfu-node:latest
    networks: 
     - lmstfu

  lmstfu-modsec:
    image: lmstfu-modsec:latest
    ports:
      - "80:80"
      - "443:443"
    networks: 
     - lmstfu

  redis:
    image: redis
    ports:
      - "6379:6379"
    networks: 
     - lmstfu

networks:
  lmstfu:
    driver: bridge
    ipam:
      driver: default
      config:
       - subnet: 172.28.0.0/16
```
