#############
# AMC Paper: Install and load necessary packages
# Christopher Gandrud
# 21 December 2012
#############

# Install & load required packages
## Based on https://gist.github.com/3710171
## See also http://bit.ly/PbabKd
doInstall <- FALSE  # Change to FALSE if you don't want packages installed.
toInstall <- c("apsrtable",
               "devtools",
               "ggplot2",
               "gridExtra",
               "MASS",
               "msm",
               "plyr",
               "RColorBrewer",
               "RCurl",
               "reshape2",
               "rworldmap",
               "Zelig")

if(doInstall){install.packages(toInstall, repos = "http://cran.us.r-project.org")}
lapply(toInstall, library, character.only = TRUE)