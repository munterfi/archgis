#!/bin/bash

# Base R and TK for installing packages (mirror window)
pacman -S --noconfirm tk r 

# Install packages
Rscript -e 'install.packages(c("magrittr", "data.table", "dplyr"),repo = "http://cran.rstudio.com/")'
Rscript -e 'install.packages(c("sf", "stars", "stplanr", "hereR"),repo = "http://cran.rstudio.com/")'
Rscript -e 'install.packages(c("ggplot2", "mapview", "plotly", "ggmap"),repo = "http://cran.rstudio.com/")'

# Install R kernel for JupyterLab
Rscript -e 'install.packages("IRkernel", repo = "http://cran.rstudio.com/")'
Rscript -e 'IRkernel::installspec()'

# Rstudio
# pacman -Syu --noconfirm
sudo -u $SUDO_USER yay -S --noconfirm rstudio-desktop-bin

