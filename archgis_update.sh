#!/bin/bash
############################################################
#  Update ArchGIS                                          #
#  Version: 0.1.0                                          #
#  File: ~/archgis/archgis_update.sh                       #
#                                                          #
#  Spatial libraries and tools on Arch Linux               #
#  -------------------------------------------------       #
#  This script updates the archgis installation.           #
#  This includes updates via pacman and yay and further    #
#  package updates for python, R and Julia.                #
#                                                          #
#  Setup:                                                  #
#     $ git clone https://github.com/munterfinger/archgis   #
#     $ cd archgis                                         #
#     $ sudo ./archgis_install.sh                          #
#                                                          #
#  Usage:                                                  #
#     $ sudo ./archgis_update.sh                           #
#                                                          #
#  GNU General Public License 3.0 - by Merlin Unterfinger   #
############################################################

if (( $EUID != 0 )); then
    echo ERROR: Updating ArchGIS failed. Please run as root.
    exit 1
fi


echo "*** Updating ArchGIS ***"

echo "(1/5) Updating pacman packages..."
pacman -Syu --noconfirm > /dev/null

echo "(2/5) Updating yay packages..."
sudo -u $SUDO_USER yay -Syu --noconfirm > /dev/null

echo "(3/5) Updating Python packages..."
source /home/$SUDO_USER/py/spatial/bin/activate
pip install -U $(pip freeze | awk '{split($0, a, "=="); print a[1]}') > /dev/null
source deactivate

echo "(4/5) Updating R packages..."
Rscript -e 'update.packages(ask = FALSE, repo = "http://cran.rstudio.com/")' > /dev/null

echo "(5/5) Updating Julia packages..."
julia -e 'using(Pkg); Pkg.update();' > /dev/null

echo Done.

