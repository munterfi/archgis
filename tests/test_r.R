############################################################
#  Test ArchGIS: R                                         #
#  Version: 0.1.0                                          #
#  File: ~/archgis/tests/test_r.R                          #
#                                                          #
#  Test spatial libraries bindings in R                    #
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
library(sf)
library(data.table)

message("Check GDAL binding: Reading geojson")
pts <- st_read("data/pts.geojson", quiet = TRUE)
poly <- st_read("data/poly.geojson", quiet = TRUE)

message("Check PROJ binding: Transforming CRS")
cent <-
  pts %>%
  st_transform(2056) %>%
  st_union() %>%
  st_centroid() %>%
  st_as_text(pretty = TRUE)

message("Check GEOS binding: Transforming CRS")
poly$EQ <-
  suppressMessages(st_intersects(poly, pts)) %>%
  lengths()

message("\nResult: ")
poly %>%
  data.table() %>%
  .[order(EQ, decreasing = TRUE), .(ADMIN, EQ)] %>%
  head(3)
message("\n")

# Done
message("*** Successfully finished ***")
