#!/bin/bash

# Install libunits form AUR
sudo -u $SUDO_USER yay -S --noconfirm udunits >/dev/null

# Spatial libraries: GDAL, GEOS and PROJ
pacman -S --noconfirm gcc-fortran gdal geos proj

