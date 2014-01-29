###############
# Create Bueno de Mesquita et al. (2003) winset data
# Christopher Gandrud
# 29 January 2014
###############

# Load library
library(devtools)
library(xtable)

# Load WinsetCreator function
source_url('https://gist.github.com/christophergandrud/8671372/raw/9cd74cb918207d1a3963a9362dbad75ff5eb47e9/WinsetCreator.R')

Win <- WinsetCreator(OutCountryID = 'imf')
names(Win) <- c('imfcode', 'country', 'year', 'W', 'ModS') 

# Create markdown variable description.

cat('W = Winset variable from Bueno de Mesquita et la. (2003)\n ModS = Modified selectorate variable based on Database of Political Institutions LIEC variable', file = "/git_repositories/amcData/MainData/VariableDescriptions/Winset.md")

# Save file
write.table(Win, file = "/git_repositories/amcData/MainData/CleanedPartial/Winset.csv", sep = ",", row.names = FALSE)
