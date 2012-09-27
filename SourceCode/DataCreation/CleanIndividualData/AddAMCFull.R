############ 
# Clean Up AMCFull Data
# Christopher Gandrud
# Updated 27 September 2012
############

## The source code in this file cleans up the raw AMCFull.csv file.
## The file AMCFull.csv can be found at: https://raw.github.com/christophergandrud/amcData/master/BaseFiles/AMCFull/AMCFull.csv
## The README file explaining this data set can be found at: http://bit.ly/RWJak3

### Note: We assume that the search for AMCs was exhaustive over these country years. 
### All country years with no AMC observed are treated as if there is actually no AMC.
 
# Load packages
library(reshape)
library(devtools)

# Set working directory and load the data.
setwd("/git_repositories/amcData/BaseFiles/AMCFull/")

#### Load Data #### 
AMCFull <- read.csv("AMCFull.csv")

# Drop source variable and notes
AMCFull <- AMCFull[, 1:18]

# Drop A6, A7, F6, F7
AMCFull$A6 <- AMCFull$A7 <- AMCFull$F6 <- AMCFull$F7 <- NULL

# Rename imfcode IMFCode
AMCFull <- rename(AMCFull, c(imfcode = "IMFCode"))

#### Keep valid jurisdiction-years (see: https://github.com/christophergandrud/JurisdictionYear) ####

# Run CountriesJurisdictions.R
source_url("https://raw.github.com/christophergandrud/JurisdictionYear/master/CountriesJurisdictions.R")

# Merge AMCFull and Countries
AMCFull <- merge(x = AMCFull, y = Countries, by = union("IMFCode", "year"), all = TRUE)

# Keep valid plus 2012
AMC <- subset(AMCFull, year == 2012 | !is.na(AMCFull$Data))
AMC <- AMC[!is.na(AMC$country.x), ]

#### Create Standardized AMC Variables ####
# NEED TO DO BASED ON G.'S RESPONSE #


#### Final clean then save ####
# Rename country.x country
AMC <- rename(AMC, c(country.x = "country"))

# Drop now extraneous variables
AMC <- AMC[, c("IMFCode", "country", "year", )]

