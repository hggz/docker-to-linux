#!/bin/bash

# These setup options are designed to run on the base OS image on a fresh install. They are taken from the corresponding docker file `Base Environment Apps` section

###### Base Environment Apps #####
# dev
pacman --noconfirm -Syyu base-devel git git-lfs
# no machine
# samba
# docker
pacman --noconfirm -Syyu docker
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
# standard notes
# steam
