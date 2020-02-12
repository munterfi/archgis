############################################################
#  Test ArchGIS: Python                                    #
#  Version: 0.1.0                                          #
#  File: ~/archgis/tests/test_python.py                    #
#                                                          #
#  Test spatial libraries bindings in Python               #
#  -------------------------------------------------       #
#  This script reads the USGS earthquake as POINTs and     #
#  the countries from Natural Earth as POLYONs using GDAL. #
#  Then it performs a CRS transformation using PROJ and    #
#  a spatial intersection operation using GEOS.            #
#                                                          #
#  Setup:                                                  #
#     $ git clone https://github.com/munterfinger/archgis  #
#     $ cd archgis                                         #
#                                                          #
#  Usage:                                                  #
#     $ ./test_archgis.sh                                  #
#                                                          #
#  GNU General Public License 3.0 - by Merlin Unterfinger  #
############################################################

# Pks
import geopandas as gpd

print('Check GDAL binding: Reading geojson')
pts <- st_read('data/pts.geojson', quiet = TRUE)
poly <- st_read('data/poly.geojson', quiet = TRUE)

print('Check PROJ binding: Transforming CRS')
cent <-
  pts %>%
  st_transform(2056) %>%
  st_union() %>%
  st_centroid() %>%
  st_as_text(pretty = TRUE)
print('Centroid EQs (EPSG:2056): ', cent)

print('Check GEOS binding: Transforming CRS')
poly$EQ <- poly %>%
  st_intersects(pts) %>%
  lengths()
poly %>%
  data.table() %>%
  .[order(EQ, decreasing = TRUE), .(ADMIN, EQ)] %>%
  head(3)

print('*** Successfully finished ***')
