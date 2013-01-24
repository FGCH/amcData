###########
# Make Data Clean and Merge
# Christopher Gandrud
# 24 January 2013
###########

# Note: Requires that Stata is in your PATH.

DIR = .

# Create list of R source files
RSOURCE = $(wildcard $(DIR)/*.R)

# Files to indicate when the RSOURCE file was run
OUT_FILES1 = $(RSOURCE:.R=.Rout)

# Default target
all: $(OUT_FILES1)

# Run the RSOURCE files
$(DIR)/%.Rout: $(DIR)/%.R
	R CMD BATCH $<

# Remove Out Files
clean:
	rm -fv $(OUT_FILES1)