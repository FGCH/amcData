###########
# Make AMCPaper1's Graphs and Tables
# Christopher Gandrud
# 22 January 2013
###########

# Note: Requires that Stata is in your PATH.

DIR = .

# Create list of R source files
RSOURCE = $(wildcard $(DIR)/*.R)

# Create list of Stata source files
SSOURCE = $(wildcard $(DIR)/*.do)

# Files to indicate when the RSOURCE file was run
OUT_FILES1 = $(RSOURCE:.R=.Rout)

# Files to indicate when the RSOURCE file was run
OUT_FILES2 = $(SSOURCE:.do=.log)

# Default target
all: $(OUT_FILES1) $(OUT_FILES2)

# Run the RSOURCE files
$(DIR)/%.Rout: $(DIR)/%.R
	R CMD BATCH $<

# Run the SSOURCE files
$(DIR)/%.log: $(DIR)/%.do
	Stata -e do $<

# Remove Out Files
clean:
	rm -fv $(OUT_FILES1) $(OUT_FILES2)