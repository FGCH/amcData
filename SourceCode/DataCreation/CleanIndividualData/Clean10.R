############
# Clean up Stijn Claessens and Neeltje van Horen Bank Ownership Data
# Christopher Gandrud
# 31 March 2013
############

#####
# Source: Stijn Claessens and Neeltje van Horen (2013)
# http://www.dnb.nl/en/onderzoek-2/databases/index.jsp
####

## Load packages
library(reshape2)
library(plyr)
library(countrycode)
library(xtable)

# Set working directory and load the data.
setwd("/git_repositories/amcData/BaseFiles/CvHBankOwnership/")

#### Load Data ####
CvHData <- read.csv("CvHBankOwnershipDatabase_def_tcm47-287454.csv")

# Keep foreign ownership dummies
CvHDataSub <- CvHData[, c(4, 5, 15, 20:34)]

# Melt data
CvHMolten <- melt(CvHDataSub, id.vars = c("country", "cntrycode","Swift"))

# rename variables
names(CvHMolten) <- c("country", "WBCode","Swift", "year", "CvHOwnership")

# Remove own from year variable
CvHMolten$year <- gsub("own", "", CvHMolten$year)
CvHMolten$year <- as.numeric(CvHMolten$year)

#### Create ownership percentage variable ####
CvHMolten$Operating <- 1
CvHMolten$Operating[is.na(CvHMolten$CvHOwnership)] <- NA

CvHMolten <- ddply(CvHMolten, .(WBCode, year), transform, ForTotal = sum(CvHOwnership, na.rm = TRUE))
CvHMolten <- ddply(CvHMolten, .(WBCode, year), transform, Total = sum(Operating, na.rm = TRUE))

attach(CvHMolten)
CvHMolten$CvHOwnPerc <- (ForTotal/Total) * 100
detach(CvHMolten)

#### Final Clean ####
CvHFinal <- CvHMolten[!duplicated(CvHMolten[, c(2, 4)]), ]

CvHFinal$imfcode <- countrycode(CvHFinal$WBCode, origin = "wb", destination = "imf")
CvHFinal <- CvHFinal[, c("imfcode", "year", "CvHOwnPerc")]

#### Variable Description File ####
ColNames <- "CvHOwnPerc"
Description <- "Percentage of majority foreign owned banks"
Date <- date()
Source <- "<a href=\"http://www.dnb.nl/en/onderzoek-2/databases/index.jsp\">Stijn Claessens and Neeltje van Horen (2013)</a>"

VarList <- cbind(ColNames, Description, Source)

VarList <- xtable(VarList)

AMCTable <- print(VarList, type = "html")

cat("# Foreign Bank Ownership\n\n\n", Date, AMCTable, file = "/git_repositories/amcData/MainData/VariableDescriptions/CvHBankOwnership.md")

# Save data file 
write.table(CvHFinal, file = "/git_repositories/amcData/MainData/CleanedPartial/CvHBankOwners.csv", sep = ",", row.names = FALSE)