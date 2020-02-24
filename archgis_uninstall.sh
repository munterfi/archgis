#!/bin/bash
############################################################
#  Uninstall ArchGIS                                       #
#  Version: 0.1.0                                          #
#  File: ~/archgis/archgis_install.sh                      #
#                                                          #
#  Spatial libraries and tools on Arch Linux               #
#  -------------------------------------------------       #
#  This script uninstalls the ArchGIS extension and        #
#  removes all environment variables and paths.            #
#                                                          #
#  Setup:                                                  #
#     $ git clone https://github.com/munterfinger/archgis   #
#     $ cd archgis                                         #
#     $ sudo ./archgis_install.sh                          #
#                                                          #
#  Usage:                                                  #
#     $ sudo archgis-uninstall                             #
#                                                          #
#  GNU General Public License 3.0 - by Merlin Unterfinger   #
############################################################

if (( $EUID != 0 )); then
    echo ERROR: Uninstalling ArchGIS failed. Please run as root.
    exit 1
fi

# Read ArchGIS profile
source /etc/profile.d/archgis_profile.sh	


echo "*** Installing ArchGIS ***"

# Update system
echo "(1/10) Updating system..."
pacman -Syu --noconfirm > /dev/null

# Copy files and export vars
echo "(2/10) Copying files and exporting variables..."
# Define vars
export ARCHGIS_PATH=/opt/archgis
export ARCHGIS_PROFILE=/etc/profile.d/archgis_profile.sh
export ARCHGIS_VERSION="'0.1.0'"
export ARCHGIS_LICENSE="'GNU General Public License 3.0'"
export ARCHGIS_AUTHOR="'Merlin Unterfinger'"
# Copy files
mkdir -p $ARCHGIS_PATH
cp -r tests -t $ARCHGIS_PATH
cp -t $ARCHGIS_PATH archgis_test.sh archgis_update.sh
cp -t $ARCHGIS_PATH LICENS
# Adding archgis env vars
echo -e '#\n# /etc/profile.d/.archgis_profile\n#\n\n# ENV' > $ARCHGIS_PROFILE
echo 'export ARCHGIS_PATH='$ARCHGIS_PATH >> $ARCHGIS_PROFILE
echo 'export ARCHGIS_PROFILE='$ARCHGIS_PROFILE >> $ARCHGIS_PROFILE
echo 'export ARCHGIS_VERSION='$ARCHGIS_VERSION >> $ARCHGIS_PROFILE
echo 'export ARCHGIS_LICENSE='$ARCHGIS_LICENSE >> $ARCHGIS_PROFILE
echo 'export ARCHGIS_AUTHOR='$ARCHGIS_AUTHOR >> $ARCHGIS_PROFILE
# Adding alias
echo -e '\n# ALIAS' >> $ARCHGIS_PROFILE
echo alias archgis-update=$ARCHGIS_PATH/'archgis_update.sh' >> $ARCHGIS_PROFILE
echo alias archgis-test=$ARCHGIS_PATH/'archgis_test.sh' >> $ARCHGIS_PROFILE
echo -e '\n# APP' >> $ARCHGIS_PROFILE

# Configure yay to access AUR packages
echo "(3/10) Configuring yay to access AUR packages..."
./src/install_yay.sh > /dev/null

# Install spatial libraries (GDAL, GEOS, PROJ, ...)
echo "(4/10) Installing spatial libraries..."
./src/install_spatlibs.sh > /dev/null

# Create new python env "spatial"
# Install spatial packages (geopandas, rasterio, ...) and Jupyter Lab
echo "(5/10) Create new Python env and install spatial packages..."
./src/install_python.sh > /dev/null

# Install R, spatial packages (data.table, sf, stars, hereR, ...) and RStudio
echo "(6/10) Installing R with spatial packages..."
./install_r.sh > /dev/null

# Install Julia and spatial packages (DataFrames, GDAL, ArchGDAL, ...)
echo "(7/10) Installing Julia with spatial packages..."
./src/install_julia.sh > /dev/null

# Install Docker
echo "(8/10) Installing Docker and enable service..."
pacman -S --noconfirm docker > /dev/null
systemctl start docker.service > /dev/null
systemctl enable docker.service > /dev/null

# Install JupyterLab and enable widgets
echo "(9/10) Installing JupyterLab and enabling widgets..."
pacman -S --noconfirm firefox jupyterlab > /dev/null
jupyter nbextension enable --py --sys-prefix widgetsnbextension > /dev/null

# Install QGIS
echo "(10/10) Installing QGIS..."
pacman -S --noconfirm qgis > /dev/null

echo "Done. Please logout and login, to make changes taking effect."

