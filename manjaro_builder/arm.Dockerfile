FROM manjarolinux/base:20230122
LABEL com.iximiuz-project="docker-to-linux-manjaro-builder"
RUN pacman  --noconfirm -Syyu --needed linux mkinitcpio systemd-sysvcompat util-linux manjaro-tools-base which grub vim parted wget dialog libarchive openssl awk cryptsetup
RUN echo "root:root" | chpasswd
