######### 
# Make amcData Data Set
# Christopher Gandrud
# Updated 24 July 2012
#########

# Set working directory 
setwd("/git_repositories/amcData/SourceCode/DataCreation/")
source("AddAMCLVStartYears.R")
setwd("/git_repositories/amcData/SourceCode/DataCreation/")
source("AddLV.R")
setwd("/git_repositories/amcData/SourceCode/DataCreation/")
source("AddDPIVariables.R")
setwd("/git_repositories/amcData/SourceCode/DataCreation/")
source("AddUDSVariable.R")
setwd("/git_repositories/amcData/SourceCode/DataCreation/")
source("MergeCleaned.R")