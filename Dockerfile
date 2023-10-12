FROM alpine:3.16 AS builder

# Install dependencies for compiling busybox
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.cqu.edu.cn/g' /etc/apk/repositories \
    && apk add gcc musl-dev make perl

# Download busybox sources
RUN wget https://busybox.net/downloads/busybox-1.35.0.tar.bz2 \
    && tar xf busybox-1.35.0.tar.bz2 \
    && mv /busybox-1.35.0 /busybox

WORKDIR /busybox

# Copy busybox build config (limited to httpd)
COPY config .config

# Compile & Install
RUN make && make install

# Create a non-root use for httpd process
RUN adduser -D www

FROM scratch

COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group
COPY --from=builder /busybox/_install/bin/busybox /bin/busybox

# USER www
COPY httpd.conf /home/www/
WORKDIR /home/www/html
COPY index.html .

# Run busybox httpd
CMD ["/bin/busybox", "httpd", "-f", "-v", "-h", "/home/www/html", "-c", "/home/www/httpd.conf"]