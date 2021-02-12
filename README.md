# docker-engage

Engage is meant as a custom lightweight container image meant for providing a go-to debugging/troubleshooting environment in multiple scenarios.
View the `Dockerfile` to see everything installed (i.e. dig, curl, telnet, psql, nmap, and more!).

*Run Locally:*

```
docker run --name engage inanimate/engage
docker exec -it engage /bin/bash
```

*In Kubernetes:*

```
kubectl apply -f deploy/deployment.yaml
```

> Other objects exist in `deploy/` like ingress, pdb, and service!

## Echo Server

Additionally, https://github.com/inanimate/echo-server is included which provides a simple http server that prints out basic details and other useful troubleshooting information.

Snippet of example output when you `curl localhost`:
```
Welcome to echo-server!  Here's what I know.
  > Head to /ws for interactive websocket echo!

-> My hostname is: echo-server-4282639374-6bvzg

-> My Pod Name is: echo-server-4282639374-6bvzg
-> My Pod Namespace is: playground
-> My Pod IP is: 10.2.1.30

-> Requesting IP: 10.2.2.0:40974
.......
```

This is immensely helpful when testing ingress flows through load balancers, verifying network policies, and other introspective details of the environment a container runs in! It also provides a Websocket connection for further testing.

## HTTPSTAT (Curl on Steroids!)

Another utility, `httpstat` is also included (the go version: https://github.com/davecheney/httpstat) which gives you amazing http response details.

```
bash-4.4# httpstat google.com

Connected to 216.58.192.174:443

HTTP/2.0 301 Moved Permanently
Server: gws
Alt-Svc: h3-29=":443"; ma=2592000,h3-T051=":443"; ma=2592000,h3-Q050=":443"; ma=2592000,h3-Q046=":443"; ma=2592000,h3-Q043=":443"; ma=2592000,quic=":443"; ma=2592000; v="46,43"
Cache-Control: public, max-age=2592000
Content-Length: 220
Content-Type: text/html; charset=UTF-8
Date: Fri, 12 Feb 2021 15:59:09 GMT
Expires: Sun, 14 Mar 2021 15:59:09 GMT
Location: https://www.google.com/
X-Frame-Options: SAMEORIGIN
X-Xss-Protection: 0

  DNS Lookup   TCP Connection   TLS Handshake   Server Processing   Content Transfer
[     18ms  |          19ms  |        103ms  |             46ms  |             0ms  ]
            |                |               |                   |                  |
   namelookup:18ms           |               |                   |                  |
                       connect:37ms          |                   |                  |
                                   pretransfer:141ms             |                  |
                                                     starttransfer:187ms            |
                                                                                total:188ms
```


Please feel free to open issues of cool features or other utilities you'd like to see. Also, feel free to use this as a base to fork from!
