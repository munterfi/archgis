#!/bin/bash

# Install python virtual envs
pacman -S --noconfirm python-virtualenv

# Create new env "spatial" in /home/<usr>/py
mkdir "/home/$SUDO_USER/py" && cd "$_"
virtualenv -p /usr/bin/python3 spatial
source spatial/bin/activate && cd -

# Install spatial packages
pip install geopandas rasterio pydeck

# Make env availale to jupyter lab
pip install ipykernel
python -m ipykernel install --name=spatial
