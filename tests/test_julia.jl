############################################################
#  Test ArchGIS: Julia                                     #
#  Version: 0.1.0                                          #
#  File: ~/archgis/tests/test_julia.jl                     #
#                                                          #
#  Test spatial libraries bindings in Julia                #
#  -------------------------------------------------       #
#  This script reads the USGS earthquake as POINTs and     #
#  the countries from Natural Earth as POLYONs using GDAL. #
#  Then it performs a CRS transformation using PROJ and    #
#  a spatial intersection operation using GEOS.            #
#                                                          #
#  Setup:                                                  #
#     $ git clone https://github.com/munterfi/archgis      #
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
using ArchGDAL;
const AG = ArchGDAL;

println("* Check GDAL binding: Reading GeoJSON")
pts = AG.read("data/pts.geojson");
poly = AG.read("data/poly.geojson");

# println("* Check PROJ binding: Transforming CRS")
# cent <-
#   pts %>%
#   st_transform(2056) %>%
#   st_union() %>%
#   st_centroid() %>%
#   st_as_text(pretty = TRUE)
# println("--> Centroid EQs (EPSG:2056): ")

# println("* Check GEOS binding: Count points in polygons")
# poly$EQ <- poly %>%
#   st_intersects(pts) %>%
#   lengths()
# poly %>%
#   data.table() %>%
#   .[order(EQ, decreasing = TRUE), .(ADMIN, EQ)] %>%
#   head(3)

println("*** Successfully finished ***")
