FROM alpine:3.5

RUN apk --update add bash \
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
ping \
tar \
xz
