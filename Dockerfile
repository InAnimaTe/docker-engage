FROM alpine:3.5

RUN apk --update --no-cache add bash \
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
    && rm -rf /var/cache/apk/*

COPY echo-server /echo-server
WORKDIR /echo-server

CMD ["./echo-server"]
