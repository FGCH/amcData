###############
# Create Bueno de Mesquita et al. (2003) winset data
# Christopher Gandrud
# 28 January 2014
###############

# Load library
library(devtools)
library(xtable)

# Load WinsetCreator function
source_url('https://gist.github.com/christophergandrud/8671372/raw/4d33d82fbe8cd44cd6732f847cbbdabc7d4eae4e/WinsetCreator.R')

Win <- WinsetCreator(OutCountryID = 'imf')
names(Win) <- c('imfcode', 'country', 'year', 'W') 

# Create markdown variable description.

cat('W = Winset variable from Bueno de Mesquita et la. (2003)', file = "/git_repositories/amcData/MainData/VariableDescriptions/Winset.md")

# Save file
write.table(Win, file = "/git_repositories/amcData/MainData/CleanedPartial/Winset.csv", sep = ",", row.names = FALSE)
