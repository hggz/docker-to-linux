FROM arm64v8/debian:bullseye
LABEL com.iximiuz-project="docker-to-linux"
RUN apt-get -y update
RUN apt-get -y install syslinux-common syslinux-efi fdisk qemu-utils
