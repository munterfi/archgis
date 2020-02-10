#!/bin/bash
##########################################################
#  Install ArchGIS                                       #
#  Version: 0.1.0                                        #
#  File: ~/archgis/update_archgis.sh                     #
#                                                        #
#  Spatial libraries and tools on Arch Linux             #
#  -------------------------------------------------     #
#  This script updates the archgis installation.         #
#  This includes updates via pacman and yay and further  #
#  package updates for python, R and Julia.              #
#                                                        #
#  Setup:                                                #
#     $ git clone https://github.com/munterfinger/archgis #
#     $ cd archgis                                       #
#                                                        #
#  Usage:                                                #
#     $ sudo ./update_archgis.sh                         #                                                       #
#                                                        #
#  GNU General Public License 3.0 - by Merlin Unterfinger #
##########################################################

if (( $EUID != 0 )); then
    echo ERROR: Installing archgis failed. Please run as root.
    exit 1
fi

echo "*** Updating ArchGIS ***"

echo "(1/5) Updating pacman packages..."
pacman -Syu --noconfirm > /dev/null 2>&1

echo "(2/5) Updating yay packages..."
sudo -u $SUDO_USER yay -Syu --noconfirm > /dev/null 2>&1

echo "(3/5) Updating python packages..."
source /home/$SUDO_USER/py/spatial/bin/activate
pip install -U $(pip freeze | awk '{split($0, a, "=="); print a[1]}') > /dev/null 2>&1

echo "(4/5) Updating r packages..."
Rscript -e 'update.packages(ask = FALSE, repo = "http://cran.rstudio.com/")' > /dev/null 2>&1

echo "(5/5) Updating julia packages..."
julia -e 'using(Pkg); Pkg.update();' > /dev/null 2>&1

echo Done.
