#!/bin/bash
############################################################
#  Update ArchGIS                                          #
#  Version: 0.1.0                                          #
#  File: ~/archgis/src/archgis_update.sh                   #
#                                                          #
#  Spatial libraries and tools on Arch Linux               #
#  -------------------------------------------------       #
#  This script updates the archgis installation.           #
#  This includes updates via pacman and yay and further    #
#  package updates for Python, R and Julia.                #
#                                                          #
#  Setup:                                                  #
#     $ git clone https://github.com/munterfi/archgis      #
#     $ cd archgis                                         #
#     $ sudo ./archgis_install.sh                          #
#                                                          #
#  Usage:                                                  #
#     $ sudo archgis-update                                #
#                                                          #
#  GNU General Public License 3.0 - by Merlin Unterfinger  #
############################################################

if (( $EUID != 0 )); then
    echo ERROR: Updating ArchGIS failed. Please run as root.
    exit 1
fi

# Read ArchGIS profile
source /etc/profile.d/archgis_profile.sh	


echo "*** Updating ArchGIS ***"

# Update using pacman
echo "(1/5) Updating pacman packages..."
pacman -Syu --noconfirm >/dev/null

# Update using yay
echo "(2/5) Updating yay packages..."
sudo -u $SUDO_USER yay -Syu --noconfirm --aur >/dev/null

# Update Python venv
echo "(3/5) Updating Python packages..."
source $ARCHGIS_PATH/python/spatial/bin/activate
pip install -U $(pip freeze | awk '{split($0, a, "=="); print a[1]}') >/dev/null

# Update R
echo "(4/5) Updating R packages..."
Rscript -e 'update.packages(ask = FALSE, repo = "http://cran.rstudio.com/")' 2>&1 >/dev/null

# Update Julia
echo "(5/5) Updating Julia packages..."
julia -e 'using(Pkg); Pkg.update();' 2>&1 >/dev/null

echo Done.

