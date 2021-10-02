#!/bin/bash

# Avoid installing julia via pacman
# pacman -S --noconfirm julia"
# ... as it causes serious issues while installing julia packages.

# Install binary directly from https://julialang.org/downloads/
vers=julia-1.3.1
cd $ARCHGIS_PATH
curl "https://julialang-s3.julialang.org/bin/linux/x64/1.3/${vers}-linux-x86_64.tar.gz" -so julia.tar.gz
tar -xzf julia.tar.gz && rm -rf julia.tar.gz && mv $vers julia && cd -

# Export PATH
echo 'export PATH=$PATH:'$ARCHGIS_PATH'/julia/bin' >>$ARCHGIS_PROFILE
source $ARCHGIS_PROFILE

# Install packages
julia -e 'import Pkg; Pkg.add("DataFrames");' >/dev/null
julia -e 'import Pkg; Pkg.add("GDAL");' >/dev/null
julia -e 'import Pkg; Pkg.add("ArchGDAL");' >/dev/null
julia -e 'import Pkg; Pkg.add("LibSpatialIndex");' >/dev/null
julia -e 'import Pkg; Pkg.add("LibGEOS");' >/dev/null
julia -e 'import Pkg; Pkg.add("Distributions");' >/dev/null
julia -e 'import Pkg; Pkg.add("Plots");' >/dev/null
julia -e 'import Pkg; Pkg.add("StatsPlots");' >/dev/null

# Make julia available to jupyter lab
julia -e 'import Pkg; Pkg.add("IJulia");' >/dev/null
