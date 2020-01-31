#!/bin/bash
##########################################################
#  Install ArchGIS                                       #
#  Version: 0.1.0                                        #
#  File: ~/archgis/install_archgis.sh                    #
#                                                        #
#  Spatial libraries and tools on Arch Linux             #
#  -------------------------------------------------     #
#  This script installs the spatial librarires GDAL,     #
#  GEOS and PROJ on an exisitng Arch Linux. Then some    #
#  common tools for reading, processing, visualizing     #
#  and storing spatial data are installed.               #
#                                                        #
#  Setup:                                                #
#     $ git clone https://github.com/munterfinger/archgis #
#     $ cd archgis                                       #
#                                                        #
#  Usage:                                                #
#     $ sudo ./install_archgis.sh                        #
#                                                        #
#  Examples:                                             #
#     $ tree                                             #
#     $ tree /etc/opt                                    #
#     $ tree ..                                          #
#                                                        #
#  GNU General Public License 3.0 - by Merlin Unterfinger #
##########################################################

if (( $EUID != 0 )); then
    echo ERROR: Installing archgis failed. Please run as root.
    exit 1
fi

# Install
cd yay && sudo -u $SUDO_USER makepkg -si --noconfirm

echo "*** Installing ArchGIS ***"

# Configure yay to access AUR packages
echo "(1/6) Installing yay..."
./src/install_yay.sh > /dev/null 2>&1

# Install spatial libraries (GDAL, GEOS, PROJ, ...)
echo "(2/6) Install spatial libraries..."
./src/install_spatlibs.sh > /dev/null 2>&1

# Create new python env "spatial"
# Install spatial packages (geopandas, rasterio, ...) and Jupyter Lab
echo "(3/6) Create new python env and install spatial packages..."
./src/install_py.sh > /dev/null 2>&1

# Install R, spatial packages (data.table, sf, stars, hereR, ...) and RStudio
echo "(4/6) Installing R with spatial packages..."
./install_r.sh > /dev/null 2>&1

# Install Julia and spatial packages (DataFrames, GDAL, ArchGDAL, ...)
echo "(5/6) Installing Julia with spatial packages..."
./src/install_julia.sh > /dev/null 2>&1

# Install QGIS
echo "(6/6) Installing QGIS..."
pacman -S --noconfirm qgis > /dev/null 2>&1

echo Done.

