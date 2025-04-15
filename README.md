# Engage - Beast Mode Debugging!

Engage is meant as a custom lightweight container image meant for providing a go-to debugging/troubleshooting environment in multiple scenarios.
View the [`Dockerfile`](https://github.com/InAnimaTe/docker-engage/blob/master/Dockerfile) to see everything installed (i.e. dig, curl, telnet, psql, nmap, and more!).

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

## Optional Variables

* `PORT` - Defines the HTTP listen port for `echo-server`, defaults to 80
* `SSLPORT` - Defines the HTTPS listen port for `echo-server`, defaults to 443
* `SSHPORT` - Defines the SSH Daemon listen port for ssh connections, defaults to 22
* `TZ` - Set the timezone, standard zones from `tzdata` package supported i.e. `America/Detroit`

See below for more optional variables depending on how you want to use Engage!

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

## DROPUSER Configuration

`docker-engage` allows you to drop privileges by creating a non-root user at runtime. This is done by setting several environment variables that will update `/etc/passwd` and `/etc/group`. When these variables are supplied, the container’s startup script automatically creates the user and grants passwordless `sudo` privileges.

> *Note this functionality is entirely optional. Merely cease passing any of these variables and use `root` by default.*

### Environment Variables

- **`DROPUSER` (required):**  
  The username that will be created inside the container.  
  _Example:_ `inanimate`

- **`DU_UID` (required):**  
  The user ID (UID) for the new user.  
  _Example:_ `1000`

- **`DU_GID` (required):**  
  The group ID (GID) for the new user's primary group.  
  _Example:_ `1000`

- **`DU_PASS` (optional):**  
  An optional password to set for the $DROPUSER, default is `engage`  
  _Example:_ `plzdonthackme`

- **`DROPGROUP` (optional):**  
  The name of the group to be created. If not provided, the group name defaults to the value of `DROPUSER`.

### How It Works

When the required environment variables are set, the container's `run` script will perform the following steps:

1. **Create a Group:**  
   A group is created with the specified GID. If the `DROPGROUP` variable is provided, that group name is used; otherwise, it defaults to the `DROPUSER` value.

2. **Create a User:**  
   A new user is created with the specified UID and primary group using the following options:
   - **`-N`**: Do not create a group with the same name as the user.
   - **`-M`**: Do not create a home directory.
   - **`-s /bin/zsh`**: Set the login shell to Zsh.
  
   The home directory will be set to the default of `/home/$DROPUSER`. Mount any storage you want to be persistent for this user to this directory.

3. **Grant Sudo Privileges:**  
   A sudoers file is created that grants the new user passwordless `sudo` access. `su` is also enabled.

*Protip:* Use `sudo -E -s` instead of `sudo su` to launch a root shell which maintains the `$DROPUSER`'s environment (`$HOME`, `$SHELL`, etc.).

### Example Usage

You can pass these environment variables when running your container. For example, using Docker:

```bash
docker run \
  -e DROPUSER=inanimate \
  -e DU_UID=1000 \
  -e DU_GID=1000 \
  -e DROPGROUP=king \
  inanimate/engage:latest
```

## Loop Mode

Engage can take a `command` you give it (i.e. via `docker-compose`) and run it
in a while loop with interval `$LOOPINTERVAL` for you!

To enable set both these environment variables (LOOPINTERVAL is any accepted timeframe `sleep` supports),
```
LOOPMODE=enabled
LOOPINTERVAL=10000s
```

and pass your desired script or one-liner for immediate execution and recurring execution every `$LOOPINTERVAL`

An example `command`:
```
docker run -ti inanimate/engage 'export NICEDATE=`date +"%Y-%m-%d_%H-%M"` && echo "starting backup with date $NICEDATE"'
```

This is especially useful if you need to run continuous checks on a process, make simple backup patterns, or have other fun usecases!

> Note, the loop will continue indefinitely as `while true` does. Please ensure you kill the process to stop your desired script from continually running!


Please feel free to open issues of cool features or other utilities you'd like to see. Also, feel free to use this as a base to fork from!
