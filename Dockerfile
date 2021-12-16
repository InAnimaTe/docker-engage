FROM alpine:3.13

RUN apk --update --no-cache add bash \
      busybox-extras \
      zsh \
      curl \
      wget \
      bind-tools \
      drill \
      mtr \
      git \
      vim \
      nano \
      iproute2 \
      iputils \
      htop \
      openssh \
      nmap \
      tmux \
      screen \
      tar \
      xz \
      tree \
      zip \
      unzip \
      rsync \
      tcpdump \
      unrar \
      redis \
      postgresql-client \
      mysql-client \
      openssh \
      openssl \
    && rm -rf /var/cache/apk/* \
    # SSH Setup \
    && ssh-keygen -A \
    && echo -e "engage\nengage" | passwd root

COPY echo-server /echo-server
COPY httpstat-bin /bin/httpstat
COPY ssh_banner /etc/issue.net
COPY motd /etc/motd
COPY run /run.sh
RUN chmod +x /run /bin/httpstat /echo-server/echo-server

# When I fix echo-server to either have certs build in or not require them to start, this will go away.
WORKDIR /echo-server

ENV PORT 80
ENV SSLPORT 443

ENTRYPOINT ["/run.sh"]
CMD ["/echo-server/echo-server & /usr/sbin/sshd -D -e -o PermitRootLogin=yes -o Banner=/etc/issue.net & wait"]
