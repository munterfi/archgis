#!/bin/bash
############################################################
#  Info about ArchGIS                                      #
#  Version: 0.1.0                                          #
#  File: ~/archgis/archgis_info.sh                         #
#                                                          #
#  Spatial libraries and tools on Arch Linux               #
#  -------------------------------------------------       #
#  This script prints the version, location and further    #
#  information about the installed ArchGIS extension.      #
#                                                          #
#  Setup:                                                  #
#     $ git clone https://github.com/munterfinger/archgis   #
#     $ cd archgis                                         #
#     $ sudo ./archgis_install.sh                          #
#                                                          #
#  Usage:                                                  #
#     $ archgis-info                                       #
#                                                          #
#  GNU General Public License 3.0 - by Merlin Unterfinger   #
############################################################

# Read ArchGIS profile
source /etc/profile.d/archgis_profile.sh	


figlet "ArchGIS"
echo "Version:    ${ARCHGIS_VERSION}"
echo "GDAL:       $(pacman -Q gdal | awk '{ print$2 }')"
echo "GEOS:       $(pacman -Q geos | awk '{ print$2 }')"
echo "PROJ:       $(pacman -Q proj | awk '{ print$2 }')"
echo "Location:   ${ARCHGIS_PATH}"
echo "Profile:    ${ARCHGIS_PROFILE}"
echo "Author:     ${ARCHGIS_AUTHOR}"
echo "License:    ${ARCHGIS_LICENSE}"
echo ""

