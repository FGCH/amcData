############ 
# Clean Up Unified Democracy Scores (2010) (UDS) Data 
# Christopher Gandrud
# Updated 17 July 2012
############

# Set working directory and load the data.
setwd("/git_repositories/amcData/BaseFiles/UDS2011/")

# Load required packages
library(countrycode)
library(reshape)
library(xtable)

# Download data from the Unified Democracy Score Website: http://www.unified-democracy-scores.org/
url <- "http://www.unified-democracy-scores.org/files/uds_summary.csv.gz"
temp <- tempfile()
download.file(url, temp)
uds <- read.csv(gzfile(temp, "uds_summary.csv"))
unlink(temp)

# Keep mean UDS score
uds <- uds[, c("country", "year", "mean")]

# Rename Mean UDS
uds <- rename(uds, c(mean = "UDS"))

# Create variable description
ColNames <- names(uds[, c(-1, -2, -4)])
Description <- c("Mean Unified Democarcy Score")
Source <- c("Melton et al. (2011)")

VarList <- cbind(ColNames, Description, Source)

VarList <- xtable(VarList)

DpiVariableTable <- print(VarList, type = "html")

cat("# Variable Label and Variable Description for Unified Democracy Score (2011) Data\n See: <http://www.unified-democracy-scores.org/uds.html>\n\n", DpiVariableTable, file = "/git_repositories/amcData/MainData/VariableDescriptions/UDSVariableDescription.md")

# Create IMF code ID variable
uds$imfcode <- countrycode(uds$country, origin = "country.name", destination = "imf")

# Save file
write.table(uds, file = "/git_repositories/amcData/MainData/CleanedPartial/UdsData.csv", sep = ",")
