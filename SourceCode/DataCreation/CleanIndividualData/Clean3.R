############ 
# Clean Up Dreher (2010) Stand-by Aggreement data
# Christopher Gandrud
# Updated 30 July 2012
############

# Load required packages
library(reshape)
library(countrycode)
library(xtable)

# Load data
# IMF stand-by aggreement
# From: http://www.uni-heidelberg.de/fakultaeten/wiso/awi/professuren/intwipol/datasets.html. Accessed July 2012.

setwd("/git_repositories/amcData/BaseFiles/DreherIMF2010/")

imf <- read.csv("DreherIMF_SBA.csv")

imf <- imf[, -1]

# Reshape variables
imf <- melt(imf, id = "Country.Name")

# Clean up
imf <- rename(imf, c(Country.Name = "country", variable = "year", value = "IMFDreher"))
imf$year <- gsub("X", "", x = imf$year)

imf <- imf[order(imf$country), ]

imf$imfcode <- countrycode(imf$country, origin = "country.name", destination = "imf")

imf <- imf[, -1]

# Create variable description
ColNames <- names(imf[, 2])
Description <- c("Year IMF stand-by aggreement was signed")
Source <- c("Dreher (2006, updated 2010)")

VarList <- cbind(ColNames, Description, Source)

VarList <- xtable(VarList)

DpiVariableTable <- print(VarList, type = "html")

cat("# Variable Label and Variable Description for Dreher IMF Stand-by Aggreement Data \n See: <http://www.uni-heidelberg.de/fakultaeten/wiso/awi/professuren/intwipol/datasets.html>\n\n", DpiVariableTable, file = "/git_repositories/amcData/MainData/VariableDescriptions/IMFDreherVariableDescription.md")

write.table(imf, file = "/git_repositories/amcData/MainData/CleanedPartial/IMFData.csv", sep = ",", row.names = FALSE)

