#!/bin/bash
############################################################
#  Test ArchGIS                                            #
#  Version: 0.1.0                                          #
#  File: ~/archgis/archgis_test.sh                         #
#                                                          #
#  Test spatial libraries and tools on Arch Linux          #
#  -------------------------------------------------       #
#  This script runs test scripts for checking the          #
#  functionality of the spatial libararies and their       #
#  correct binding in python, R and Julia.                 #
#                                                          #
#  Setup:                                                  #
#     $ git clone https://github.com/munterfinger/archgis   #
#     $ cd archgis                                         #
#     $ sudo ./archgis_install.sh                          #
#                                                          #
#  Usage:                                                  #
#     $ ./archgis_test.sh                                  #
#                                                          #
#  GNU General Public License 3.0 - by Merlin Unterfinger   #
############################################################


echo "*** Testing ArchGIS ***"

echo "(1/5) Downloading test data (USGS earthquake and counrtries)..."
mkdir -p tests/data && cd "$_"
curl https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson -so pts.geojson
curl https://raw.githubusercontent.com/datasets/geo-countries/master/data/countries.geojson -so poly.geojson
cd - && cd tests > /dev/null

echo "(3/5) Checking Python spatial bindings..."
#source /home/$SUDO_USER/py/spatial/bin/activate
$ARCHGIS_PATH/python/spatial/bin/python test_python.py

echo "(3/5) Checking R spatial bindings..."
Rscript test_r.R

echo "(4/5) Checking Julia spatial bindings..."
julia test_julia.jl

echo "(5/5) Removing test data..."
cd - > /dev/null
rm -rf tests/data

echo Done.

