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


echo "*** Uninstalling ArchGIS ***"

# Update system
echo "(1/10) Updating core, extra and community packages..."
pacman -Syu --noconfirm > /dev/null

echo "(2/10) Removing tools (JupyterLab, QGIS)..."
pacman -Rs --noconfirm firefox jupyterlab qgis > /dev/null
sudo -u $SUDO_USER yay -Rs --noconfirm rstudio-desktop-bin > /dev/null

echo "(2/10) Removing Docker..."
pacman -Rs --noconfirm docker > /dev/null

echo "(2/10) Removing Python, R and Julia..."
pacman -Rs --noconfirm r > /dev/null
rm -rf $ARCHGIS_PATH/python > /dev/null
rm -rf $ARCHGIS_PATH/julia > /dev/null

echo "(2/10) Removing spatial libaries..."
pacman -Rs --noconfirm gcc-fortran gdal geos proj > /dev/null
sudo -u $SUDO_USER yay -Rs --noconfirm udunits > /dev/null

echo "(2/10) Removing ArchGIS profile and env vars..."
rm -rf $ARCHGIS_PATH > /dev/null
rm -rf $ARCHGIS_PROFILE > /dev/null
#echo "source ${ARCHGIS_PROFILE}" >> /etc/bash.bashrc

echo "(2/10) Removing yay..."
pacman -Rs --noconfirm yay > /dev/null

echo "Done. Please logout and login, to make changes taking effect."

