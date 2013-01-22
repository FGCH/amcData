#############
# AMC Paper: Heatmap
# Christopher Gandrud
# 22 January 2013
#############

# Depends on: 
# library(devtools)
# source_url("https://raw.github.com/christophergandrud/amcData/master/SourceCode/Paper1Source/LoadRPackages.R")
# source_url("https://raw.github.com/christophergandrud/amcData/master/SourceCode/Paper1Source/PaperDataLoadClean.R")

library(ggplo2)

# Create transition matrix
StateTable <- statetable.msm(state = AMCStatus, subject = ISOCode, data = AMCLag)

### Remove 'to' and 'from'
StateTable <- unname(StateTable)

### Change row and column names/ change to data frame
rownames(StateTable) <- c("No AMC", "Centralised", "Decentralised")
colnames(StateTable) <- c("No AMC", "Centralised", "Decentralised")
StateTableDF <- data.frame(StateTable)

### Subset just reforms

StateTableDF <- subset(StateTableDF, Var1 != Var2)

### Create heatmap
pdf(file = "~/Dropbox/AMCPaper1/figure/TransitionMatrix.pdf")
ggplot(StateTableDF, aes(Var2, Var1)) +
                      geom_tile(aes(fill = Freq)) +
                      geom_text(aes(label = Freq)) +
                      scale_fill_gradient2(low = "white", high = "red", name = "") +
                      xlab("\nAfter") + ylab("Before\n") +
                      theme_bw()
dev.off()
