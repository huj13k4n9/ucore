# Start with Ubuntu 14.04 base image
FROM ubuntu:14.04

COPY build.sh /

# Install LXDE, VNC server
RUN sed -i "s/archive.ubuntu.com/mirrors.aliyun.com/g" /etc/apt/sources.list && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
# Set up the compile environment
  apt-get install -y \
    build-essential \
    gcc-multilib \
    make \
    qemu-system-x86 && \
  apt-get clean all && \
  useradd -ms /bin/bash build

USER build

# Copy VNC script that handles restarts
CMD ["/build.sh"]
