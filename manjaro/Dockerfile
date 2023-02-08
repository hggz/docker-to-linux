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
RUN pacman --noconfirm -Syyu which vim
RUN pacman --noconfirm -Syyu firefox
###### Base Environment Apps #####
## Note: use these setup instructions scripts for your base vm image
####### Host Packages #######
# qemu/kvm
# virtual machine manager
# barrier
# no machine
# docker
# vim
# tmux
###### Personal Desktop Env ######
# no machine
# docker
# vim
# tmux
# swift
# ruby
# python
# lua
# bitwarden
# pgadmin
# postman
# rubymine
# visual studio code
# chromium
# ebuild
# steam

# Desktop Viewing Packages launch
#Vnc - TODO
#RUN pacman --noconfirm -Syyu firefox x11vnc xorg-server-xvfb xorg-xauth
#RUN echo "exec firefox" > ~/.xinitrc && chmod +x ~/.xinitrc
#CMD ["/usr/sbin/x11vnc", "-create", "-forever"]
# X11
CMD ["startxfce4"]
#RUN /bin/sh -c Configfile="~/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml" && echo "#! /bin/bash\nxdpyinfo | grep -q -i COMPOSITE || {\n  echo 'x11docker/xfce: X extension COMPOSITE is missing.\nWindow manager compositing will not work.\nIf you run x11docker with option --nxagent,\nyou might want to add option --composite.' >&2\n  [ -e $Configfile ] || {\n    mkdir -p $(dirname $Configfile)\n    echo '<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<channel name=\"xfwm4\" version=\"1.0\">\n\n  <property name=\"general\" type=\"empty\">\n    <property name=\"use_compositing\" type=\"bool\" value=\"false\"/>\n  </property>\n</channel>\n' > $Configfile\n  }\n}\nstartxfce4\n" > /usr/local/bin/start && chmod +x /usr/local/bin/start
