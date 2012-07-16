############ 
# Clean Up Laeven & Valencia (2012) Banking Crisis Data
# Christopher Gandrud
# Updated 16 July 2012
############

# Input data and transform it into long format
# Laeven & Valencia (2012) data can be found at: http://www.imf.org/external/pubs/cat/longres.aspx?sk=26015.0
# The data set 'SYSTEMIC BANKING CRISES DATABASE.xlsx' was downloaded. The 'Additional Details' sheet was saved as a .csv file called  'LavValPolicies.csv' in a folder called LavVal2012.

# Set working directory and load the data.
setwd("~/LavVal2012/")

restruct <- read.csv("LavValPolicies.csv")

# Take the matrix transpose to reshape the data from wide to long format. 
restruct.r <- t(restruct)

# Write new table.
write.table(restruct.r, file = "restruct.csv", sep = ",")