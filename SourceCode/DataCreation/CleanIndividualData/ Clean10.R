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

# Set working directory and load the data.
setwd("/git_repositories/amcData/BaseFiles/CvHBankOwnership/")

#### Load Data ####
CvHData <- read.csv("CvHBankOwnershipDatabase_def_tcm47-287454.csv")

# Keep foreign ownership dummies
CvHDataSub <- CvHData[, c(4, 5, 15, 20:34)]

# Melt data
CvDMolten <- melt(CvHDataSub, id.vars = c("country", "cntrycode","Swift"))

# rename variables
names(CvDMolten) <- c("country", "WBCode","Swift", "year", "CvDOwnership")

# Remove own from year variable
CvDMolten$year <- gsub("own", "", CvDMolten$year)
CvDMolten$year <- as.numeric(CvDMolten$year)

# Create ownership percentage variable
CvDMolten$Operating <- 1
CvDMolten$Operating[is.na(CvDMolten$CvDOwnership)] <- NA