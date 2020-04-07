# ArchGIS <img src="docs/figures/archgis_logo.png" align="right" alt="" width="120" />

ArchGIS is an extension for Arch Linux that expands it with the most common
spatial libraries (GDAL, GEOS and PROJ) and tools (Python, R, Julia and Docker) for
reading, processing, analyzing, visualizing and storing spatial data sets.
The installation of the ArchGIS extension requires a proper Arch Linux installation
with a desktop environment (e.g. Gnome) as starting point. The desktop environment
is required as ArchGIS also contains GUI applications (JupyterLab, RStudio, QGIS).
To set up a fresh Arch Linux installation, follow these instructions: [Setting up Arch Linux for ArchGIS](docs/SETUP.md)

**Note:** ArchGIS is designed to be installed by user with sudo rights,
but not as root itself. If no user with root privileges exists yet,
create one and log in with the newly created user before proceeding with the
installation:
``` bash
# Replace <username> with the user name:
useradd -m <username>
passwd <username>
usermod -a -G wheel,audio,video,optical,storage,power <username>

# Enable `sudo` for the wheel group:
visudo
> uncomment: %wheel ALL=(ALL) ALL
> write and quit: :wq
```

## Installing ArchGIS
Clone the repository from github and run the installer script:
``` bash
git clone https://github.com/munterfinger/archgis.git
cd archgis
sudo ./install.sh
```
This will take a few minutes: Time for a coffee :)
![](/docs/figures/archgis_desktop.png)
(archgis-info, RStudio, jupyterlab)

## Testing ArchGIS

To print information about the installed ArchGIS version, type:

``` bash
archgis-info
>     _             _      ____ ___ ____  
>    / \   _ __ ___| |__  / ___|_ _/ ___| 
>   / _ \ | '__/ __| '_ \| |  _ | |\___ \ 
>  / ___ \| | | (__| | | | |_| || | ___) |
> /_/   \_\_|  \___|_| |_|\____|___|____/ 
>                                         
> Version:    0.1.0
> GDAL:       3.0.4-4
> GEOS:       3.8.0-1
> PROJ:       6.3.1-1
> Location:   /opt/archgis
> Profile:    /etc/profile.d/archgis_profile.sh
> Author:     Merlin Unterfinger
> License:    GNU General Public License 3.0
> 
```

In order to test the ArchGIS installation run the test script:
``` bash
archgis-test
```

This command uses earthquake data from the USGS Hazard feed and country polygons
from Natural Earth, which have been downloaded during the installation of ArchGIS.
These data sets are then read in by Python, R and Julia using GDAL to check the binding
to this library. Then CRS transformations are performed using PROJ and spatial
intersections using GEOS. If the test finishes successfully, the spatial libraries
are installed properly and the bindings to Python, R and Julia are correct.


## Updating ArchGIS
To update ArchGIS including the Python, R and Julia packages run the updater script as root:
``` bash
sudo archgis-update
```
Since Arch Linux has a very active community, updates should be carried out regularly.

## Examples
Docker: PostGIS, OSRM
JupyterLab: Choose spatial

## References

* Arch Linux: https://archlinux.org
* GDAL: https://gdal.org
* PROJ: https://proj.org
* GEOS: https://trac.osgeo.org/geos
