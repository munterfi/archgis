# ArchGIS

ArcGIS is an extension for Arch Linux that expands it with the most common
spatial libraries (GDAL, GEOS and PROJ) and tools (Python, R, Julia and QGIS) for
reading, processing, analyzing, visualizing and storing spatial data sets.
The installation of the ArchGIS extension requires a proper Arch Linux installation
with a desktop environment (e.g. Gnome) as starting point. The desktop environment
is required as also contains GUI applications (Jupyter Lab, RStudio, QGIS).
To set up a fresh Arch Linux installation, follow these instructions: [Setting up Arch Linux](docs/archlinux_setup.md)

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
sudo ./archgis_install.sh
```
This will take a few minutes: Time for a coffee :)

![](/docs/figures/archgis.png)


## Testing ArchGIS
In order to test the ArchGIS installation run the test script:
``` bash
./archgis_test.sh
```

## Updating ArchGIS
To update ArchGIS including the R, Python and Julia packages run the updater script:
``` bash
sudo ./archgis_update.sh
```

## References

* Arch: https://archlinux.org
* GDAL: https://gdal.org
* PROJ: https://proj.org
* GEOS: https://trac.osgeo.org/geos
