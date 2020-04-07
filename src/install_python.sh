#!/bin/bash

# Install python virtual envs
pacman -S --noconfirm python-virtualenv python-distlib

# Create new env "spatial" in /opt/archgis
mkdir -p $ARCHGIS_PATH'/python' && cd "$_"
virtualenv -p /usr/bin/python3 spatial
. spatial/bin/activate && cd -

# Install spatial packages
pip install numpy matplotlib rtree shapely pygeos libpysal geopandas rasterio pydeck

# Make env available to jupyter lab
pip install ipykernel
python -m ipykernel install --name=spatial

# Deactivate virtual env
deactivate

# Create alias "pysp"
echo alias pysp=$ARCHGIS_PATH'/python/spatial/bin/python' >> $ARCHGIS_PROFILE
