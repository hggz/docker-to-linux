# build with: docker build -f Dockerfile -t manjaro_xfce .
# run with: docker container run --privileged -e DISPLAY=docker.for.mac.host.internal:0 -v /tmp/.X11-unix:/tmp/.X11-unix --net host -it manjaro_xfce
# NOTE: use the above for mac. Here are more mac debug steps:

# had to After running XQuartz and setting the Preferences/Security/"Allow connections from network clients" option, you must restart XQuartz. (It may be the case that after install, you must logoff/logon again, but I found that merely restarting XQuartz was sufficient.) Afterwards, when XQuartz is running again, you should see it listening on port 6000

# xhost +localhost

# NOTE: when launching firefox first time - didn't work. Remedied by opening terminal, killall firefox, relaunching and it worked.

FROM manjarolinux/base:20230122
LABEL com.iximiuz-project="docker-to-linux"
RUN pacman  --noconfirm -Syyu --needed linux systemd-sysvcompat
RUN echo "root:root" | chpasswd

# Baseline usable system 

# Desktop setup
# XFCE
RUN pacman --noconfirm -Syyu xfce4 xfce4-goodies xfce4-terminal network-manager-applet xfce4-notifyd xfce4-whiskermenu-plugin tumbler engrampa manjaro-xfce-settings manjaro-settings-manager

# update lightdm
#RUN mkdir -p /etc/lightdm; touch /etc/lightdm/lightdm-gtk-greeter.conf
#RUN echo "[greeter] \
#background = /usr/share/backgrounds/illyria-default-lockscreen.jpg \
#font-name = Cantarell Bold 12 \
#xft-antialias = true \ 
#icon-theme-name = Papirus \
#screensaver-timeout = 60 \
#theme-name = Matcha-azul \
#cursor-theme-name = xcursor-breeze \
#show-clock = false \
#default-user-image = #avatar-default \
#xft-hintstyle = hintfull \
#position = 50%,center 50%,center \
#clock-format = \
#panel-position = bottom \
#indicators = ~host;~spacer;~clock;~spacer;~language;~session;~a11y;~power" >> /etc/lightdm/lightdm-gtk-greeter.conf

# Add primary user
RUN useradd -mG lp,network,power,sys,wheel hggz
RUN echo "hggz:hggz" | chpasswd

# add x11 to stream env via docker
# pmisc xdg-utils need to be installed but are already
# x11-xserver-utils x11-utils needed but went for xorg-apps
RUN pacman --noconfirm -Syyu dbus xorg-apps
RUN pacman --noconfirm -Syyu firefox
###### Base Environment Apps #####
RUN pacman --noconfirm -Syyu base-devel git git-lfs
## Note: use these setup instructions scripts for your base vm image
####### Host Packages #######
# qemu/kvm virtual machine manager
# remove iptables if it exists (if it asks) so I added '--ask 4'. All ask bitmaps are here: 
RUN pacman --noconfirm -Syyu --needed virt-manager qemu-desktop libvirt edk2-ovmf dnsmasq iptables-nft --ask 4
# set the service. Enable it in docker, but start it on a running system...comment out the start on the system setup scripts for an already running machine
RUN sudo systemctl enable libvirtd.service; #sudo systemctl start libvirtd.service
# add user to libvirt group to use the system-level vms (qemu://system. USER MUST BE SAME AS ABOVE
RUN sudo usermod -a -G libvirt hggz
# TODO - prepare Virtio driver https://wiki.manjaro.org/index.php/Virt-manager
# install guest additions
# samba
# looking glass
# barrier
# no machine
# docker
RUN sudo pacman --noconfirm -Syyu docker
# set the service. Enable it in docker, but start it on a running system...comment out the start on the system setup scripts for an already running machine
RUN sudo systemctl enable docker.service; #sudo systemctl start docker.service;
# run without root (same user above)
RUN sudo usermod -aG docker hggz
# docker compose
RUN sudo pacman --noconfirm -Syyu docker-compose

# vim zsh tmux
RUN sudo pacman --noconfirm -Syyu vim tmux zsh
# TODO - configs
# wireguard
# Desktop Viewing Packages launch
#Vnc - TODO
#RUN pacman --noconfirm -Syyu firefox x11vnc xorg-server-xvfb xorg-xauth
#RUN echo "exec firefox" > ~/.xinitrc && chmod +x ~/.xinitrc
#CMD ["/usr/sbin/x11vnc", "-create", "-forever"]
# X11
CMD ["startxfce4"]
#RUN /bin/sh -c Configfile="~/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml" && echo "#! /bin/bash\nxdpyinfo | grep -q -i COMPOSITE || {\n  echo 'x11docker/xfce: X extension COMPOSITE is missing.\nWindow manager compositing will not work.\nIf you run x11docker with option --nxagent,\nyou might want to add option --composite.' >&2\n  [ -e $Configfile ] || {\n    mkdir -p $(dirname $Configfile)\n    echo '<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<channel name=\"xfwm4\" version=\"1.0\">\n\n  <property name=\"general\" type=\"empty\">\n    <property name=\"use_compositing\" type=\"bool\" value=\"false\"/>\n  </property>\n</channel>\n' > $Configfile\n  }\n}\nstartxfce4\n" > /usr/local/bin/start && chmod +x /usr/local/bin/start
