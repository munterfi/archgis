#!/bin/bash

# Install python virtual envs
pacman -S --noconfirm python-virtualenv

# Create new env "spatial"
virtualenv -p /usr/bin/python3 spatial
source spatial/bin/activate

# Install spatial packages
pip install geopandas rasterio pydeck

