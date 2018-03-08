# docker-engage

Engage is meant as a custom lightweight container image meant for providing a go-to debugging/troubleshooting environment in multiple scenarios.
View the `Dockerfile` to see everything installed (note some packages include multiple commands i.e. dig).

Additionally, https://github.com/inanimate/echo-server is included which provides a simple http server that prints out basic details and other useful troubleshooting information. Another utility, `httpstat` is also included (the go version: https://github.com/davecheney/httpstat) which gives you amazing http response details.
By default, the `echo-server` runs at container launch. To change this, just change the command you pass in:

```
docker run -ti inanimate/engage /bin/bash
Welcome to Engage! There are a ton of tools in this container and echo-server is running so "curl locahost" for some quick details. More details here: https://github.com/InAnimaTe/docker-engage
Starting /bin/bash on default ports now!
+ /bin/bash
```

Please feel free to open issues of cool features or other utilities you'd like to see. Also, definitely use this as a base to fork from for your own custom container!
