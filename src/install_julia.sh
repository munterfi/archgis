#!/bin/bash

# Install Julia
pacman -S --noconfirm julia

# Install packages
julia -e 'using(Pkg); Pkg.add("DataFrames");'
julia -e 'using(Pkg); Pkg.add("Distributions");'
julia -e 'using(Pkg); Pkg.add("RDatasets");'
julia -e 'using(Pkg); Pkg.add("Plots");'
julia -e 'using(Pkg); Pkg.add("StatsPlots");'

# Make available to jupyter lab
julia -e 'using(Pkg); Pkg.add("IJulia");'

# Create named pipe
#mkfifo pipe

# Keep pipe alive
#sleep 1000 > pipe &

# Make Julia read from pipe
#julia < pipe &
#echo 'using(Pkg)' > pipe
#echo 'Pkg.add("DataFrames")' > pipe 
#echo 'exit()' > pipe
#echo 'while true end' > pipe

