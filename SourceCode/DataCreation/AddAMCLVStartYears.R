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
amcStart <- amcStart[1:68, c("Country", "Crisis.Start", "AMC.start")]

# Rename variables
amcStart <- rename(amcStart, c(Country = "country", Crisis.Start = "CrisisYear", AMC.start = "year"))

# Remove Deposit Insurers
amcStart <- subset(amcStart, year != "1933!!!")
amcStart <- subset(amcStart, year != "1816!!!")

# Remove Non-crisis 
amcStart <- subset(amcStart, CrisisYear != "???")

# Keep only years (remove months)
amcStart$CrisisYear <- as.numeric(str_extract(amcStart$CrisisYear, "[1-2][0,9][0-9][0-9]"))
amcStart$year <- gsub("[\x80-\xFF]", "", amcStart$year)
amcStart$year <- as.numeric(str_extract(amcStart$year, "[1-2][0,9][0-9][0-9]"))

# Drop Czech pre-crisis institutions
amcStart <- amcStart[!is.na(amcStart$CrisisYear), ]

# Add IMF code
amcStart$imfcode <- countrycode(amcStart$country, origin = "country.name", destination = "imf")

# Create variable descriptions
ColNames <- names(amcStart[, "year"])
Description <- c("The year that an AMC was created.")
Date <- date()
Source <- paste("Gathered by authors. Current as of", Date, sep = " ")

VarList <- cbind(ColNames, Description, Source)

VarList <- xtable(VarList)

DpiVariableTable <- print(VarList, type = "html")

cat("# AMC Start Years", DpiVariableTable, file = "/git_repositories/amcData/MainData/VariableDescriptions/AMCStartYears.md\n\n")

# Save file 
write.table(amcStart, file = "/git_repositories/amcData/MainData/CleanedPartial/amcStartData.csv", sep = ",")
