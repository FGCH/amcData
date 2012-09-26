############ 
# Clean Up AMCFull Data
# Christopher Gandrud
# Updated 26 September 2012
############

## The source code in this file cleans up the raw AMCFull.csv file.
## The file AMCFull.csv can be found at: https://raw.github.com/christophergandrud/amcData/master/BaseFiles/AMCFull/AMCFull.csv
## The README file explaining this data set can be found at: http://bit.ly/RWJak3

### Note: We assume that the search for AMCs was exhaustive over these country years. All country
### All country years with no AMC observed are treated as if there is actually no AMC
 
# Set working directory and load the data.
setwd("/git_repositories/amcData/BaseFiles/AMCFull/")

# Load Data 
AMCFull <- read.csv("AMCFull.csv")

# Drop source variable and notes
AMCFull <- AMCFull[, 1:18]

# Drop A6, A7, F6, F7
AMCFull$A6 <- AMCFull$A7 <- AMCFull$F6 <- AMCFull$F7 <- NULL

