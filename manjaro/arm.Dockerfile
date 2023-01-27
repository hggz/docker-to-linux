FROM manjarolinux/base:20230122
LABEL com.iximiuz-project="docker-to-linux"
RUN pacman  --noconfirm -Syyu --needed linux systemd-sysvcompat
RUN echo "root:root" | chpasswd

