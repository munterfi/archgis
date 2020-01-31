#!/bin/bash

# Install Julia
pacman -S --noconfirm julia

# Install spatial packages
julia < 'using(Pkg); Pkg.add("DataFrames")' &
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

