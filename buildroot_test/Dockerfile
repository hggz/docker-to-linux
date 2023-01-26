FROM amd64/ubuntu:20.04
LABEL com.iximiuz-project="buildroot"
RUN apt-get update -y
RUN apt-get -y install \
  wget

# get buildroot
RUN wget https://buildroot.org/downloads/buildroot-2022.11.tar.gz
RUN tar xvzf buildroot-2022.11.tar.gz

# install deps
RUN apt-get -y install patch cpio python unzip rsync bc bzip2 ncurses-dev git make g++
WORKDIR buildroot-2022.11
RUN make aarch64_efi_defconfig
RUN make
