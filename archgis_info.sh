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
#     $ ./archgis_info.sh                                  #
#                                                          #
#  GNU General Public License 3.0 - by Merlin Unterfinger   #
############################################################

. /etc/profile.d/archgis_profile.sh	
V_GDAL=`pacman -Q gdal | awk '{ print$2 }'`
V_GEOS=`pacman -Q geos | awk '{ print$2 }'`
V_PROJ=`pacman -Q proj | awk '{ print$2 }'`

figlet 'ArchGIS'
echo 'Version:    '$ARCHGIS_VERSION
echo 'GDAL:       '$V_GDAL
echo 'GEOS:       '$V_GEOS
echo 'PROJ:       '$V_PROJ
echo 'Location:   '$ARCHGIS_PATH
echo 'Profile:    '$ARCHGIS_PROFILE
echo 'License:    '$ARCHGIS_LICENSE
echo 'Author:     '$ARCHGIS_AUTHOR
echo ''
