#!/bin/bash

# Clone yay from GitHub
git clone https://aur.archlinux.org/yay.git

# Install
cd yay && sudo -u $SUDO_USER makepkg -si --noconfirm

# Remove repo
cd - && rm -rf yay

