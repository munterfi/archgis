#!/bin/bash
############################################################
#  Install ArchGIS                                         #
#  Version: 0.1.0                                          #
#  File: ~/archgis/archgis_install.sh                      #
#                                                          #
#  Spatial libraries and tools on Arch Linux               #
#  -------------------------------------------------       #
#  This script installs the spatial librarires GDAL,       #
#  GEOS and PROJ on an exisitng Arch Linux. Then some      #
#  common tools for reading, processing, visualizing       #
#  and storing spatial data are installed.                 #
#                                                          #
#  Setup:                                                  #
#     $ git clone https://github.com/munterfinger/archgis  #
#     $ cd archgis                                         #
#                                                          #
#  Usage:                                                  #
#     $ sudo ./archgis_install.sh                          #
#                                                          #
#  GNU General Public License 3.0 - by Merlin Unterfinger  #
############################################################

if (( $EUID != 0 )); then
    echo ERROR: Installing archgis failed. Please run as root.
    exit 1
fi

echo "*** Installing ArchGIS ***"


# Update system
echo "(1/9) Updating system..."
pacman -Syu --noconfirm > /dev/null

# Configure yay to access AUR packages
echo "(2/9) Configuring yay to access AUR packages..."
./src/install_yay.sh > /dev/null

# Install spatial libraries (GDAL, GEOS, PROJ, ...)
echo "(3/9) Installing spatial libraries..."
./src/install_spatlibs.sh > /dev/null

# Create new python env "spatial"
# Install spatial packages (geopandas, rasterio, ...) and Jupyter Lab
echo "(4/9) Create new python env and install spatial packages..."
./src/install_py.sh > /dev/null

# Install R, spatial packages (data.table, sf, stars, hereR, ...) and RStudio
echo "(5/9) Installing R with spatial packages..."
./install_r.sh > /dev/null

# Install Julia and spatial packages (DataFrames, GDAL, ArchGDAL, ...)
echo "(6/9) Installing Julia with spatial packages..."
./src/install_julia.sh > /dev/null

# Install Docker
echo "(7/9) Installing Docker..."
pacman -S --noconfirm docker > /dev/null
systemctl start docker.service
systemctl enable docker.service

# Install JupyterLab and enable widgets
echo "(8/9) Installing JupyterLab..."
pacman -S --noconfirm firefox jupyterlab > /dev/null
jupyter nbextension enable --py --sys-prefix widgetsnbextension > /dev/null

# Install QGIS
echo "(9/9) Installing QGIS..."
pacman -S --noconfirm qgis > /dev/null

echo Done.