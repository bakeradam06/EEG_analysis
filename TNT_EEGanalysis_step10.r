# EEG analysis

################################################################################
####### CMC analysis, potenitally for dissertation, conference abstracts #######
################################################################################

## load libraries
library(readr) # for reading csv files
library(dplyr) # for data manipulation
library(ggplot2) # for visualization

# import CSV file with subject IDs and analyze CMC over time, as well as beta vs gamma, muscle, brain region, etc
# set working directory to folder with all step9 excel files
cmc_data <- read.csv("/Users/DOB223/Library/CloudStorage/OneDrive-MedicalUniversityofSouthCarolina/Documents/lab/studies/1eeg/TNTanalysis/cmcDataTNT.csv")

## sanity check to assess if the import in matlab was done correctly

# first, check how many rows there are per subject
summary_by_subject <- cmc_data %>%
    group_by(Subject) %>%
    dplyr::summarise(n_rows = n()) %>%
    arrange(n_rows)
# bar graph of it
ggplot(summary_by_subject, aes(x = Subject, y = n_rows)) +
    geom_bar(stat = "identity", fill = "steelblue") +
    theme_minimal() +
    labs(
        title = "Rows per Subject",
        x = "Subject",
        y = "Number of Rows"
    )

# second, check if missing data in any subject.
# the rule here: data values must be >= minimum value of 5760 entries, otherwise error. (except for those wihtout full dataset, e.g., missing FU)
# Got 5760 because for full dataset we have 120 trials per session (pre, post, FU). 60 under each condition (vib, no vib) for each. Since we're looking at beta and gamma, and under prep and execution phases, and across 4 different muscles, we should have 120 trials x 3 sessions x 2 phases x 2 bands x 4 muscles = 5760 rows per subject minimum (again, for those with full dataset). Therefore,

missingData <- summary_by_subject %>%
    filter(n_rows < 5760)

tnt05_data <- cmc_data %>%
    filter(Subject == "TNT05")

tnt05_data %>%
    group_by(timePoint, Condition) %>%
    dplyr::summarise(n = n()) %>%
    arrange(timePoint, Condition)
