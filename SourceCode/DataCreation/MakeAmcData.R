######### 
# Make amcData Data Set
# Christopher Gandrud
# Updated 7 November 2012
#########

# Install required packages
## Code based on https://gist.github.com/3710171
## See also http://bit.ly/PbabKd
doInstall <- FALSE  # Change to FALSE if you don't want packages installed.
toInstall <- c("WDI", "countrycode", "devtools", "reshape", "gdata", "xtable")
if(doInstall){install.packages(toInstall, repos = "http://cran.us.r-project.org")}

# Run clean up files
setwd("/git_repositories/amcData/SourceCode/DataCreation/CleanIndividualData/")
  source("AddAMCFull.R")
setwd("/git_repositories/amcData/SourceCode/DataCreation/CleanIndividualData/")
  source("AddLVFullCrisisYears.R")
setwd("/git_repositories/amcData/SourceCode/DataCreation/CleanIndividualData/")
  source("AddLV.R")
setwd("/git_repositories/amcData/SourceCode/DataCreation/CleanIndividualData/")
  source("AddDPIVariables.R")
setwd("/git_repositories/amcData/SourceCode/DataCreation/CleanIndividualData/")
  source("AddUDSVariable.R")
setwd("/git_repositories/amcData/SourceCode/DataCreation/CleanIndividualData/")
  source("AddWorldBank.R")
setwd("/git_repositories/amcData/SourceCode/DataCreation/CleanIndividualData/")
  source("AddDreherIMF.R")

# Create merged data set
## Country-Year data
setwd("/git_repositories/amcData/SourceCode/DataCreation/Merge/")
  source("MergeSurvival.R")

# Tidy workspace
rm(list = setdiff(ls(), "amcCountryYear"))