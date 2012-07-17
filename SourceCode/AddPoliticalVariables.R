############ 
# Clean Up Database of Political Institutions (2010) (DPI) Data and Merge it with 
# Laeven & Valencia (2012) Crisis Restructuring Data
# Christopher Gandrud
# Updated 17 July 2012
############

# Set working directory and load the data.
setwd("/git_repositories/amcData/BaseFiles/DPI2010")

# Load required packages
library(foreign)

# Download zipped data from the IMF's DPI website: http://go.worldbank.org/2EAGGLRZ40
temp <- tempfile()
download.file("http://siteresources.worldbank.org/INTRES/Resources/469232-1107449512766/DPI2010_stata9.zip", destfile = temp)
file(unz(temp, "DPI2010_stata9.dta"))
DPI <- Stata.file(unz(temp, "DPI2010_stata9.dta"))
unlink(temp)

