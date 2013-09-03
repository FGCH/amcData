############
# MONA Data Filter
# Christopher Gandrud
# 3 September
############

# Load packages and functions
library(devtools)
source_gist("6421551") # Load grepl.sub

## The original IMF Monitoring of Fund Arrangements database was downloaded from http://www.imf.org/external/np/pdr/mona/index.aspx. Accessed Fall 2013.

#### Load data from 2002 ####
MONA <- read.csv("/git_repositories/amcData/BaseFiles/MONA/MONA_From2002.csv", 
                 stringsAsFactors = FALSE)

# Subset AMC data
SubPatterns1 <- c("(AMC)", " AMC ", "asset management company", " exit ", 
                 "capital")
SubMONA <- grepl.sub(data = MONA, patterns = SubPatterns1, var = "Descpt")

SubPatterns2 <- c("Financial sector legal reforms, regulation, and supervision",
                  "Central bank operations and reforms")
SubMONA <- grepl.sub(data = SubMONA, patterns = SubPatterns2, var = "EconDescrpt")

#### Load data from before 2002 ####

