######### 
# Make amcData Data Set
# Christopher Gandrud
# Updated 28 September 2012
#########

# Install required packages
## Based on https://gist.github.com/3710171
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

# Create merged data sets 
## Country-Crisis data
setwd("/git_repositories/amcData/SourceCode/DataCreation/Merge/")
  source("MergeCrisis.R")
## Country-Year data
setwd("/git_repositories/amcData/SourceCode/DataCreation/Merge/")
  source("MergeSurvival.R")