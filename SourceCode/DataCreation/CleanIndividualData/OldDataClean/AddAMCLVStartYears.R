############ 
# Clean Up LV AMC Start Years
# Christopher Gandrud
# Updated 25 July 2012
############

# Load required packages
library(reshape)
library(countrycode)
library(stringr)
library(xtable)

# Set working directory and load the data.
setwd("/git_repositories/amcData/BaseFiles/AMCStart/")

# Load data
amcStart <- read.csv("AMCStart.csv", sep = ";")

# Keep Laeven & Valencia AMCs
amcStart <- amcStart[1:68, c("Country", "Crisis.Start","AMC.start")]

# Rename variables
amcStart <- rename(amcStart, c(Country = "country", Crisis.Start = "CrisisYear", AMC.start = "AMCStartYear"))

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

AMCStartYearsTable <- print(VarList, type = "html")

cat("# AMC Start Years Data Set Description\n\n\n", AMCStartYearsTable, file = "/git_repositories/amcData/MainData/VariableDescriptions/AMCStartYears.md")

# Save data file 
write.table(amcStart, file = "/git_repositories/amcData/MainData/CleanedPartial/amcStartData.csv", sep = ",")
