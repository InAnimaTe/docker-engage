FROM alpine:3.21

COPY echo-server /echo-server
COPY httpstat-bin /bin/httpstat
COPY ssh_banner /etc/issue.net
COPY motd /etc/motd
COPY run /run.sh

RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "https://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk --update --no-cache add bash \
      busybox-extras \
      coreutils \
      rhash \
      zsh \
      shadow \
      curl \
      wget \
      wget2 \
      bind-tools \
      drill \
      mtr \
      git \
      vim \
      nano \
      ack \
      bat \
      file \
      inotify-tools \
      fd \
      fdupes \
      at \
      iproute2 \
      iputils \
      htop \
      openssh \
      nmap \
      tmux \
      screen \
      tar \
      xz \
      zstd \
      lrzip \
      par2cmdline \
      tree \
      zip \
      7zip \
      unzip \
      rsync \
      rclone \
      aria2 \
      mediainfo \
      dust \
      ncdu \
      tcpdump \
      redis \
      postgresql-client \
      mysql-client \
      openssh \
      openssl \
      sshfs \
      jq \
      yq \
      lftp \
      ncftp \
      yt-dlp \
      fio \
      pv \
      httrack \
    && rm -rf /var/cache/apk/* \
    ## Use q instead of dig - https://github.com/natesales/q \
    && curl -sSL https://github.com/natesales/q/releases/download/v0.19.2/q_0.19.2_linux_amd64.tar.gz | tar -xz -C /usr/local/bin q \
    && chmod +x /usr/local/bin/q \
    && chsh -s /bin/zsh root \
    && echo 'alias dig="q"' >> /root/.zshrc \
    ## SSH Setup \
    && ssh-keygen -A \
    && echo -e "engage\nengage" | passwd root \
    ## Chmod the rest of our utils we copied in earlier \
    && chmod +x /run /bin/httpstat /echo-server/echo-server

# When I fix echo-server to either have certs build in or not require them to start, this will go away.
WORKDIR /echo-server

ENV PORT 80
ENV SSLPORT 443

ENTRYPOINT ["/run.sh"]
CMD ["/echo-server/echo-server & /usr/sbin/sshd -D -e -o PermitRootLogin=yes -o Banner=/etc/issue.net & wait"]
