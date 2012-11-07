#############
# AMC Late October 2012 Data Explore
# Christopher Gandrud
# 7 November 2012
#############

# Load libraries
library(RCurl)
library(countrycode)
library(googleVis)
library(reshape)

setwd("~/Desktop/TestSlideshow/")

# Load most recent data
URL <- "https://raw.github.com/christophergandrud/amcData/master/MainData/amcCountryYear.csv"
Full <- getURL(URL)
Full <- read.csv(textConnection(Full))

# Clean for mapping 
Full <- rename(Full, c(NumAMCCountryNoNA = "TotalAmcCreated"))

#### Function to produce maps ####
MapAMC <- function(y){
                      yearTemp <- y  
                      TempMap <-  gvisGeoMap(subset(Full, year == yearTemp & TotalAmcCreated != 0), 
                                              locationvar = "ISOCode", numvar = "TotalAmcCreated",
                                              options = list(
                                                              colors = "[0xECE7F2, 0xA6BDDB, 0x2B8CBE]"
                                                            ))
  print(TempMap, file = paste("AMCMap", yearTemp, ".html", sep = ""), tag = "chart")
}

#### Apply function to create maps ####
# Vector of years for maps
Years <- c(1980, 1985, 1990, 1995, 2000, 2005, 2011)

lapply(Years, MapAMC)