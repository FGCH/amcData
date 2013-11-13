#############
# AMC Paper: Basic AMC World Map
# Christopher Gandrud
# 12 November 2013
#############

# Depends on: 
# library(devtools)
# source_url("https://raw.github.com/christophergandrud/amcData/master/SourceCode/Paper1Source/PaperSource1.R")

library(rworldmap)
library(RColorBrewer)

# Join data to country polygon data 
MapAMCData <- joinCountryData2Map(subset(AMC, year == 2011 & NumAMCCountryNoNA != 0), 
                                  joinCode = "ISO2", nameJoinColumn = "ISOCode")

# Create world map
pdf(file = "~/Dropbox/AMCProject/figure/TotalMap.pdf")
mapCountryData(MapAMCData, nameColumnToPlot = "NumAMCCountryNoNA", numCats = 6, catMethod = c(1, 2, 3, 4, 5, 6),
                         colourPalette = brewer.pal(6, "Oranges"),
                         mapTitle = "")
dev.off()
