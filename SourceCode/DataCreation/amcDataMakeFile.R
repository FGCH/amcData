######### 
# Make amcData Data Set
# Christopher Gandrud
# Updated 17 July 2012
#########

# Set working directory 
setwd("/git_repositories/amcData/SourceCode/DataCreation/")

source("LV_Data_Clean.R")
setwd("/git_repositories/amcData/SourceCode/DataCreation/")
source("AddDPIVariables.R")
setwd("/git_repositories/amcData/SourceCode/DataCreation/")
source("AddUDSVariables.R")
setwd("/git_repositories/amcData/SourceCode/DataCreation/")
source("MergeCleaned.R")