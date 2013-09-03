############
# MONA Data Filter
# Christopher Gandrud
# 3 September
############

# Load packages and functions
library(stringr)
library(lubridate)
library(countrycode)
library(devtools)
source_gist("6421551") # Load grepl.sub

## The original IMF Monitoring of Fund Arrangements database was downloaded from http://www.imf.org/external/np/pdr/mona/index.aspx. Accessed Fall 2013.

#### Load data from 2002 ####
MONAF <- read.csv("/git_repositories/amcData/BaseFiles/MONA/MONA_From2002.csv", 
                 stringsAsFactors = FALSE)

# Subset AMC data
SubPatterns1 <- c("(AMC)", " AMC ", "asset management company", "asset mgt. co.", "amc")
SubMONAF <- grepl.sub(data = MONAF, patterns = SubPatterns1, var = "Descpt")

SubPatterns2F <- c("Financial sector legal reforms, regulation, and supervision",
                  "Central bank operations and reforms", 
                  "Restructuring and privatization of financial institutions",
                  "General government")
SubMONAF <- grepl.sub(data = SubMONAF, patterns = SubPatterns2F, var = "EconDescrpt")

#### Load data from before 2002 ####
MONAB <- read.csv("/git_repositories/amcData/BaseFiles/MONA/MONA_Before2002.csv", 
                 stringsAsFactors = FALSE)

SubPatterns2B <- c("Financial", "Systemic and ownership reform")
SubMONAB <- grepl.sub(data = MONAB, patterns = SubPatterns1, var = "Description")
SubMONAB <- grepl.sub(data = SubMONAB, patterns = SubPatterns2B, var = "Economic.Descriptor")

# Create comparable variable names
StandardNames <- c("ArrID", "CountryName", "Country.Code", "ArrType",                   
                   "ApprovalDate", "Approval.Year",                      
                   "Initial.End.Date", "Initial.End.Year",                   
                   "Duration.Of.Annual.Arrangement.From", "Duration.Of.Annual.Arrangement.To",  
                   "Program.Type", "Review.Type",                       
                   "Review.Status", "Board.Doc..No.",                     
                   "Key.Code",  "EconDescrpt",                
                   "Descpt", "PC.Status", "Comments", "Sort", "EsOrder")
names(SubMONAB) <- StandardNames
KeepVars <- c("CountryName", "ArrID", "ArrType", "ApprovalDate", "EconDescrpt", "Descpt")
SubMONAF <- SubMONAF[, KeepVars]
SubMONAB <- SubMONAB[, KeepVars]

#### Combine data sets ####
Comb <- rbind(SubMONAB, SubMONAF)

# Remove trailing white space
Comb$CountryName <- str_trim(Comb$CountryName)
Comb$ApprovalDate <- str_trim(Comb$ApprovalDate)

# Drop duplicate programs
Comb <- Comb[!duplicated(Comb$ArrID), ]

# Create IMF Code and year variables
Comb$imfcode <- countrycode(Comb$CountryName, origin = "country.name", destination = "imf")
Comb$year <- as.numeric(str_sub(Comb$ApprovalDate, -4, -1))

#### Stripped down merge variable #### 
CombStrip <- Comb[, c("imfcode", "year")]
CombStrip$IMF.AMC <- 1

# Save for merge
write.csv(CombStrip, "/git_repositories/amcData/MainData/CleanedPartial/IMF_MONA.csv")
