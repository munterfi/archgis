#!/bin/bash
############################################################
#  Uninstall ArchGIS                                       #
#  Version: 0.1.0                                          #
#  File: ~/archgis/src/archgis_install.sh                  #
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

echo "Do you wish to remove ArchGIS inluding all spatial libraries?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) exit;;
    esac
done

# Read ArchGIS profile
source /etc/profile.d/archgis_profile.sh	


echo "*** Uninstalling ArchGIS ***"

# Update system
echo "(1/7) Updating core, extra and community packages..."
pacman -Syu --noconfirm >/dev/null

echo "(2/7) Removing tools (JupyterLab, QGIS)..."
pacman -R --noconfirm jupyterlab >/dev/null
pacman -Rs --noconfirm qgis >/dev/null
pacman -Rs --noconfirm figlet >/dev/null
sudo -u $SUDO_USER yay -Rs --noconfirm rstudio-desktop-bin >/dev/null

echo "(3/7) Removing Docker..."
pacman -Rs --noconfirm docker >/dev/null

echo "(4/7) Removing Python env, R and Julia..."
pacman -Rs --noconfirm r >/dev/null
pacman -Rs --noconfirm tk >/dev/null
pacman -Rs --noconfirm python-virtualenv >/dev/null
pacman -Rs --noconfirm python-distlib >/dev/null
rm -rf $ARCHGIS_PATH/python >/dev/null
rm -rf $ARCHGIS_PATH/julia >/dev/null

echo "(5/7) Removing spatial libaries..."
pacman -Rs --noconfirm gcc-fortran >/dev/null
pacman -Rs --noconfirm gdal >/dev/null
pacman -Rs --noconfirm geos >/dev/null
pacman -Rs --noconfirm proj >/dev/null
sudo -u $SUDO_USER yay -Rs --noconfirm udunits >/dev/null

echo "(6/7) Removing ArchGIS profile and env vars..."
rm -rf $ARCHGIS_PATH >/dev/null
rm -rf $ARCHGIS_PROFILE >/dev/null
sed -i '/archgis_profile/d' /etc/bash.bashrc

echo "(7/7) Removing yay..."
pacman -Rs --noconfirm yay >/dev/null

echo "Done. Please logout and login, to make changes taking effect."

