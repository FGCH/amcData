############ 
# Clean Up Database of Political Institutions (2012) (DPI) Data
# Christopher Gandrud
# Updated 27 January 2014
############

# Set working directory and load the data.
setwd("/git_repositories/amcData/BaseFiles/DPI2012/")

# Load required packages
library(foreign)
library(countrycode)
library(xtable)
library(reshape)
library(DataCombine)

# Download zipped data from the IMF's DPI website: http://go.worldbank.org/2EAGGLRZ40
dpiLong <- read.dta("DPI2012.dta", convert.dates = FALSE)

# Keep specific variables
dpi <- dpiLong[, c("countryname", "year", "yrcurnt", "govfrac", "execrlc", "checks", "polariz", 'percent1', 'percentl', 'prtyin')] 

# Change missing value code from -999 to NA
dpiMissing <- c("yrcurnt", "govfrac", "execrlc", "checks", "polariz", 'percent1', 'percentl', 'prtyin')

for (u in dpiMissing){
  dpi[[u]][dpi[[u]] == -999] <- NA
}

# Create dichotomous chief executive election year dummy 
dpi$ElectionYear[dpi$yrcurnt == 0] <- "ElectionYear"
dpi$ElectionYear[dpi$yrcurnt > 0] <- "NotElectionYear"

# Relable economic ideology variable
dpi$execrlc[dpi$execrlc == 0] <- NA
dpi$execrlc[dpi$execrlc == 1] <- "Right"
dpi$execrlc[dpi$execrlc == 2] <- "Center"
dpi$execrlc[dpi$execrlc == 3] <- "Left"

# Add IMF code id variable
dpi$imfcode <- countrycode(dpi$countryname, origin = "country.name", destination = "imf")

# Rename countryname
dpi <- rename(dpi, c(countryname = "country"))

dpi <- MoveFront(dpi, 'imfcode')

# Create variable descriptions
ColNames <- names(dpi[, c(-1, -2, -3)])
Description <- c("Years left in the chief executive's current term", "Government party fractionalization", "Chief executive's conomic policy orientation", "Number of veto players", "Veto player polarization", "Year of an executive election (created from yrcurnt = 0)", "President got what % of votes in the 1st/only round?", "President got what % of votes in the final round?", "Party of chief executive has been how long in office")
Source <- c("DPI (2012)")

VarList <- cbind(ColNames, Description, Source)

VarList <- xtable(VarList)

DpiVariableTable <- print(VarList, type = "html")

cat("# Variable Labels and Variable Descriptions for DPI (2010) Data\n See: <http://go.worldbank.org/2EAGGLRZ40>\n\n", DpiVariableTable, file = "/git_repositories/amcData/MainData/VariableDescriptions/DPIVariableDescriptions.md")

# Save file
write.table(dpi, file = "/git_repositories/amcData/MainData/CleanedPartial/DpiData.csv", sep = ",")



