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
#     $ archgis-test                                       #
#                                                          #
#  GNU General Public License 3.0 - by Merlin Unterfinger   #
############################################################

# Read ArchGIS profile
source /etc/profile.d/archgis_profile.sh	


echo "*** Testing ArchGIS ***"
cd $ARCHGIS_PATH/tests/

# Test Python
echo "(1/3) Checking Python spatial bindings..."
$ARCHGIS_PATH/python/spatial/bin/python test_python.py

# Test R 
echo "(2/3) Checking R spatial bindings..."
Rscript test_r.R

# Test Julia
echo "(3/3) Checking Julia spatial bindings..."
julia test_julia.jl

cd - > /dev/null

echo Done.

