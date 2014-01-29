############ 
# Clean Up Unified Democracy Scores (2010) (UDS) and Polity IV
# Christopher Gandrud
# Updated 29 January 2014
############

# Load required packages
library(countrycode)
library(reshape)
library(xtable)

#### UDS ####
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

# Replace West Germany with Germany
uds$country <- as.character(uds$country)
uds$country[uds$country == "Germany West"] <- "Germany"
uds <- subset(uds, country != "Germany East")

# Remove North Korea
uds$country[uds$country == "Korea South"] <- "Korea"
uds <- subset(uds, country != "Korea North")

# Create IMF code ID variable
uds$imfcode <- countrycode(uds$country, origin = "country.name", destination = "imf")

#### Polity IV ####
# Load data
setwd("/git_repositories/amcData/BaseFiles/PolityIV/")
polityIV <- read.csv("p4v2012.csv")

# Clean Polity data
polityIV$imfcode <- countrycode(polityIV$country, origin = "country.name", 
                                destination = "imf")
polityIV <- polityIV[, c("imfcode", "year", "polity2", 'durable')]
polityIV <- subset(polityIV, !is.na(imfcode))

#### Merge Data Sets ####
CombinedDem <- merge(uds, polityIV, by = c("imfcode", "year"), all = TRUE)
CombinedDem <- CombinedDem[order(CombinedDem$imfcode, CombinedDem$year) , ]

# Drop duplicates
CombinedDem <- CombinedDem[!duplicated(CombinedDem[, 1:2]), ]

#### Create variable description ####
ColNames <- names(CombinedDem[, c(-1, -2, -3)])
Description <- c("Mean Unified Democarcy Score", "Polity2 measure of democracy")
Source <- c("Melton et al. (2011)", "Marshall and Jaggers, (2011)")

VarList <- cbind(ColNames, Description, Source)

VarList <- xtable(VarList)

DpiVariableTable <- print(VarList, type = "html")

cat("# Variable Label and Variable Description for Unified Democracy Score (2011) Data\n See: <http://www.unified-democracy-scores.org/uds.html>\n\n", DpiVariableTable, file = "/git_repositories/amcData/MainData/VariableDescriptions/UDSVariableDescription.md")

# Save file
write.table(CombinedDem, file = "/git_repositories/amcData/MainData/CleanedPartial/UdsData.csv", sep = ",")
