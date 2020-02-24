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
#     $ sudo ./archgis_install.sh                          #
#     $ sudo ./archgis_update.sh                           #
#                                                          #
#  Usage:                                                  #
#     $ ./archgis_test.sh                                  #
#                                                          #
#  GNU General Public License 3.0 - by Merlin Unterfinger  #
############################################################

# Pks
import geopandas as gpd

print('* Check GDAL binding: Reading GeoJSON')
pts = gpd.read_file('data/pts.geojson')
poly = gpd.read_file('data/poly.geojson')

print('* Check PROJ binding: Transforming CRS')
cent = pts.to_crs("EPSG:2056").unary_union.centroid.wkt
print('--> Centroid EQs (EPSG:2056):', cent)

print('* Check GEOS binding: Count points in polygons')
counts = gpd.sjoin(pts, poly, op='within').groupby("ADMIN")["id"].count().sort_values(ascending=False)
print('--> Result:')
print(counts.head(3))

print('*** Successfully finished ***')
