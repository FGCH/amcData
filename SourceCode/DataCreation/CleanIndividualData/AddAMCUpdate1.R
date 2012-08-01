############ 
# Clean Up LV AMC + Others Start Years
# 1 August update
# Christopher Gandrud
# Updated 1 August 2012
############

# Load required packages
library(reshape)
library(countrycode)
library(stringr)
library(xtable)

# Set working directory and load the data.
setwd("/git_repositories/amcData/BaseFiles/AMCStart/")

# Load data
amcStart <- read.csv("AMCStartUpdate1.csv", sep = ";")

# Keep AMCs
amcStart <- amcStart[-1, ]
amcStart <- amcStart[1:90, ]
amcStart <- subset(amcStart, Country != "ADDITIONAL")
amcStart <- subset(amcStart, Country != "")
amcStart <- subset(amcStart, AMC...DF...BB != "GB")
amcStart <- subset(amcStart, AMC...DF...BB != "stabil fund")
amcStart <- subset(amcStart, X.1 != "")

# Rename variables
amcStart <- rename(amcStart, c(Country = "country", Crisis.Start = "CrisisYear", X.1 = "AMCStartYear"))

############## Not completed ##################


# Remove Deposit Insurers
amcStart <- subset(amcStart, AMCStartYear != "1933!!!")
amcStart <- subset(amcStart, AMCStartYear != "1816!!!")

# Remove Non-crisis 
amcStart <- subset(amcStart, CrisisYear != "???")

# Keep only years (remove months)
amcStart$CrisisYear <- as.numeric(str_extract(amcStart$CrisisYear, "[1-2][0,9][0-9][0-9]"))
amcStart$AMCStartYear <- gsub("[\x80-\xFF]", "", amcStart$AMCStartYear)
amcStart$AMCStartYear <- as.numeric(str_extract(amcStart$AMCStartYear, "[1-2][0,9][0-9][0-9]"))

# Create AMC start year variable
amcStart$AMCDummy[!is.na(amcStart$AMCStartYear)] <- "1"

# Add IMF code
amcStart$imfcode <- countrycode(amcStart$country, origin = "country.name", destination = "imf")

# Create variable descriptions
ColNames <- names(amcStart[, "AMCDummy"])
Description <- c("Dummy variable for whether or not an AMC was created in a given year.")
Date <- date()
Source <- paste("Gathered by authors. Current as of", Date, sep = " ")

VarList <- cbind(ColNames, Description, Source)

VarList <- xtable(VarList)

DpiVariableTable <- print(VarList, type = "html")

cat("# AMC Start Years Data Set Description\n\n\n", DpiVariableTable, file = "/git_repositories/amcData/MainData/VariableDescriptions/AMCStartYears.md")

# Save file 
write.table(amcStart, file = "/git_repositories/amcData/MainData/CleanedPartial/amcStartData.csv", sep = ",")
