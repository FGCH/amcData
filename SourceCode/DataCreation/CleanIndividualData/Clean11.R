################
# Import and clean Kuncic (2013) Institutional Quality Dataset
# Christopher Gandrud
# 1 April 2013
################

#####
# Source Kuncic (2013)
# https://sites.google.com/site/aljazkuncic/research
#####

# Load packages
library(repmis)
library(countrycode)
library(xtable)

# Load data  
URL <- "https://docs.google.com/spreadsheet/pub?key=0AtSgiY60tn0_dEtYUVo4TWlFOU01dnRjTE1WZmFTUWc&single=true&gid=0&output=csv"  
InsQualData <- source_data(URL, sep = ",", header = TRUE)

# Clean up
InsQualData$imfcode <- countrycode(InsQualData$wbcode, "wb", "imf")
IQSub <- InsQualData[, c("imfcode", "year", "legal_abs", "political_abs", "economic_abs")]

#### Variable description table ####
ColNames <- c("legal_abs", "political_abs", "economic_abs")
Description <- c("Absolute legal institutional quality (simple averages)",
				 "Absolute political institutional quality (simple averages)",
				 "Absolute economic institutional quality(simple averages)"
				)
Date <- date()
Source <- c("Kuncic (2013) (https://sites.google.com/site/aljazkuncic/research)",
			"Kuncic (2013) (https://sites.google.com/site/aljazkuncic/research)",
			"Kuncic (2013) (https://sites.google.com/site/aljazkuncic/research)"
			)

VarList <- cbind(ColNames, Description, Source)

VarList <- xtable(VarList)

InsQualTable <- print(VarList, type = "html")

cat("# Institutional Quality Composit Indicators\n\n\n", Date, InsQualTable, file = "/git_repositories/amcData/MainData/VariableDescriptions/InstQualityKucic.md")


# Save data file 
write.table(IQSub, file = "/git_repositories/amcData/MainData/CleanedPartial/InsQualKuncic.csv", sep = ",", row.names = FALSE)