#############
# AMC Basic Map Over Time
# Christopher Gandrud
# 9 November 2012
#############

# Load libraries
library(repmis)
library(googleVis)
library(reshape)

setwd("/git_repositories/amc-site/BaseMaps/")

# Load most recent data
Full <- source_GitHubData("https://raw.github.com/christophergandrud/amcData/master/MainData/amcCountryYear.csv")

# Clean for mapping 
Full <- rename(Full, c(NumAMCCountryNoNA = "TotalAmcCreated"))

#### Function to produce maps ####
MapAMC <- function(y){
                      yearTemp <- y  
                      TempMap <-  gvisGeoMap(subset(Full, year == yearTemp & TotalAmcCreated != 0), 
                                              locationvar = "ISOCode", numvar = "TotalAmcCreated",
                                              options = list(
                                                              colors = "[0xECE7F2, 0xA6BDDB, 0x2B8CBE]",
                                                              width = "780px",
                                                              height = "500px"
                                                            ))
  print(TempMap, file = paste("AMCMap", yearTemp, ".html", sep = ""), tag = "chart")
}

#### Apply function to create maps ####
# Vector of years for maps
Years <- c(1980, 1985, 1990, 1995, 2000, 2005, 2012)

lapply(Years, MapAMC)