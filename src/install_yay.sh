#!/bin/bash

# Clone yay from GitHub
sudo -u $SUDO_USER git clone --quiet https://aur.archlinux.org/yay.git

# Install
cd yay && sudo -u $SUDO_USER makepkg -si --noconfirm 2>&1 >/dev/null

# Remove repo
cd - >/dev/null
rm -rf yay >/dev/null

