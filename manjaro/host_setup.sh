#!/bin/bash

# These setup options are designed to run on the base OS image on a fresh install. They are taken from the corresponding docker file `Base Environment Apps` section

###### Base Environment Apps #####
# dev
pacman --noconfirm -Syyu base-devel git git-lfs
# qemu/kvm virtual machine manager
pacman --noconfirm -Syyu --needed virt-manager qemu-desktop libvirt edk2-ovmf dnsmasq iptables-nft
# enable and start the service
sudo systemctl enable libvirtd.service; sudo systemctl start libvirtd.service
# add user to libvirt group to use the system-level vms (qemu://system. USER MUST BE SAME AS ABOVE
sudo usermod -a -G libvirt hggz
# TODO - prepare Virtio driver https://wiki.manjaro.org/index.php/Virt-manager
# install guest additions
# samba
# looking glass
# barrier
# no machine
# docker
sudo pacman --noconfirm -Syyu docker
# set the service
sudo systemctl start docker.service; sudo systemctl enable docker.service
# run without root (same user above)
sudo usermod -aG docker hggz
# docker compose
sudo pacman --noconfirm -Syyu docker-compose

# vim zsh tmux
sudo pacman --noconfirm -Syyu vim tmux zsh
# TODO - configs
# wireguard
