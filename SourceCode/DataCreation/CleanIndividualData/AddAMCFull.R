############ 
# Clean Up AMCFull Data
# Christopher Gandrud
# Updated 28 September 2012
############

## The source code in this file cleans up the raw AMCFull.csv file.
## The file AMCFull.csv can be found at: https://raw.github.com/christophergandrud/amcData/master/BaseFiles/AMCFull/AMCFull.csv
## The README file explaining this data set can be found at: http://bit.ly/RWJak3

### Note: We assume that the search for AMCs was exhaustive over these country years. 
### All country years with no AMC observed are treated as if there is actually no AMC.
 
# Load packages
library(reshape)
library(devtools)
library(xtable)

# Set working directory and load the data.
setwd("/git_repositories/amcData/BaseFiles/AMCFull/")

#### Load Data #### 
AMCFull <- read.csv("AMCFull.csv")

# Drop source variable and notes
AMCFull <- AMCFull[, 1:21]

# Drop A6, A7, F6, F7 (no countries were observed to have more than 5 AMCs)
AMCFull$A6 <- AMCFull$A7 <- AMCFull$F6 <- AMCFull$F7 <- NULL

#### Keep valid jurisdiction-years (see: https://github.com/christophergandrud/JurisdictionYear) ####

# Run CountriesJurisdictions.R
source_url("http://bit.ly/Pbcfls")

# Merge AMCFull and Countries
AMCFull <- merge(x = AMCFull, y = Countries, by = union("imfcode", "year"), all = TRUE)

# Keep valid plus 2012
AMC <- subset(AMCFull, year == 2012 | !is.na(AMCFull$Data))
AMC <- AMC[!is.na(AMC$country.x), ]

# Remove Countries object
rm(Countries)

# Rename country.x country
AMC <- rename(AMC, c(country.x = "country"))

#### Clean key variables ####
# Create variables assuming NA = no AMC exists
AMC$NumAMCOpNoNA <- AMC$NumAMCOp
AMC$NumAMCOpNoNA[is.na(AMC$NumAMCOpNoNA)] <- 0

AMC$NumAMCCountryNoNA <- AMC$NumAMCCountry
AMC$NumAMCCountryNoNA[is.na(AMC$NumAMCCountryNoNA)] <- 0

AMC$NumAMCCountryLagNoNA <- AMC$NumAMCCountryLag
AMC$NumAMCCountryLagNoNA[is.na(AMC$NumAMCCountryLagNoNA)] <- 0

#### Final clean then save ####
# Drop now extraneous variables
AMC <- AMC[, c("imfcode", "country", "year", 
               "AMCType", "NumAMCOpNoNA", "NumAMCCountryNoNA", "NumAMCCountryLagNoNA", 
               "F1", "F2",  "F3", "F4", "F5")]

#### Create variable descriptions ####
ColNames <- names(AMC[, c("AMCType", "NumAMCOpNoNA", "NumAMCCountryNoNA", "NumAMCCountryLagNoNA", 
                          "F1", "F2",  "F3", "F4", "F5")])
Description <- c("Whether the AMC is centralized or decentralised",
                 "How many AMCs are operating in a given year (assume missing = 0)",
                 "How many AMCs have been opened since 1980 up to and including a given year (assume missing = 0)",
                 "How many AMCs have been opened since 1980 up to, but not including a given year (assume missing = 0)",
                 "Governance type of 1st AMC.",
                 "Governance type of 2nd AMC.",
                 "Governance type of 3rd AMC.",
                 "Governance type of 4th AMC.",
                 "Governance type of 5th AMC.")
Date <- date()
Source <- paste("Gathered by authors, with research assistance provided by Grzegorz Wolszczak.")

VarList <- cbind(ColNames, Description, Source)

VarList <- xtable(VarList)

AMCTable <- print(VarList, type = "html")

cat("# Full AMC Data Set Description\n\n\n", Date, AMCTable, file = "/git_repositories/amcData/MainData/VariableDescriptions/AMCFull.md")

# Save data file 
write.table(AMC, file = "/git_repositories/amcData/MainData/CleanedPartial/AMCFull.csv", sep = ",", row.names = FALSE)

