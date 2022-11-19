# BBHttpd Container Image

> This repo is forked from [docker-static-website](https://github.com/lipanski/docker-static-website).  

A very same Docker image (~160KB) to run a httpd web server, based on the [Busybox httpd](https://www.busybox.net/) static file server.  

# Version Tags

This image's tag(version) will follow the version of Busybox.  

- [1.35.0, 1.35, latest](./Dockerfile)  

## Usage

The image is hosted on [Docker Hub](https://hub.docker.com/u/mengzyou/bbhttpd):  

```Dockerfile
FROM mengzyou/bbhttpd:latest

# Copy your static files
COPY --from=builder --chown=www:www /home/node/app/output /home/www/html
```

Run the image:

```shell
docker container run --rm -it -p 8000:80 mengzyou/bbhttpd:latest
```

Browser to `http://localhost:8000/` .  

## Customize httpd.conf

You can write your `httpd.conf` file with below functions:  

- Configure httpd as a reverse proxy:  

```
P:/some/old/path:[http://]hostname[:port]/some/new/path
```

- Overwrite the default error pages:  

```
E404:404.html
```

- Implement allow/deny rules:  

```
A:172.20.       # Allow addresses from 172.20.0.0/16
A:10.0.0./25    # Allow any address from 10.0.0.0 - 10.0.0.127
A:127.0.0.1     # Allow local loopback connections
D:*             # Deny from other IP connections
```

You can find the documentation for Busybox httpd at [source code comments](https://git.busybox.net/busybox/tree/networking/httpd.c).  