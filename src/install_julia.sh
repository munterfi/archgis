#!/bin/bash

# Install Julia
pacman -S --noconfirm julia

# Install packages
julia -e 'import Pkg; Pkg.add("DataFrames");'
julia -e 'import Pkg; Pkg.add("GDAL");'
julia -e 'import Pkg; Pkg.add("ArchGDAL");'
julia -e 'import Pkg; Pkg.add("LibSpatialIndex");'
julia -e 'import Pkg; Pkg.add("LibGEOS");'
julia -e 'import Pkg; Pkg.add("Distributions");'
julia -e 'import Pkg; Pkg.add("Plots");'
julia -e 'import Pkg; Pkg.add("StatsPlots");'

# Make available to jupyter lab
julia -e 'import Pkg; Pkg.add("IJulia");'

