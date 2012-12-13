#############
# AMC Paper: Basic AMC World Map
# Christopher Gandrud
# 13 December 2012
#############

# Depends on: 
# library(devtools)
# 

# Join data to country polygon data 
MapAMCData <- joinCountryData2Map(subset(AMC, year == 2011 & NumAMCCountryNoNA != 0), 
                                  joinCode = "ISO2", nameJoinColumn = "ISOCode")

# Create world map
mapCountryData(MapAMCData, nameColumnToPlot = "NumAMCCountryNoNA", numCats = 6, catMethod = c(1, 2, 3, 4, 5, 6),
                         colourPalette = brewer.pal(6, "GnBu"),
                         mapTitle = "")