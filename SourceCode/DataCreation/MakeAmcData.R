######### 
# Make amcData Data Set
# Christopher Gandrud
# Updated 26 July 2012
#########

# Run clean up files
setwd("/git_repositories/amcData/SourceCode/DataCreation/CleanIndividualData/")
  source("AddAMCLVStartYears.R")
setwd("/git_repositories/amcData/SourceCode/DataCreation/CleanIndividualData/")
  source("AddLV.R")
setwd("/git_repositories/amcData/SourceCode/DataCreation/CleanIndividualData/")
  source("AddDPIVariables.R")
setwd("/git_repositories/amcData/SourceCode/DataCreation/CleanIndividualData/")
  source("AddUDSVariable.R")

# Create merged data sets 
## Country-Crisis data
setwd("/git_repositories/amcData/SourceCode/DataCreation/Merge/")
  source("MergeCrisis.R")
## Country-Year data
setwd("/git_repositories/amcData/SourceCode/DataCreation/Merge/")
  source("MergeSurvival.R")