# EEG analysis

################################################################################
####### CMC analysis, potenitally for dissertation, conference abstracts #######
################################################################################

## load libraries
library(readr) # for reading csv files
library(dplyr) # for data manipulation
library(ggplot2) # for visualization
library(tidyr) # for data tidying

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


# ---------------------- # ---------------------- #
# ------------- add some motor data ------------- #
# ---------------------- # ---------------------- #

# load in csv data with demographics & motor data
motor_demog_data <- read_csv("/Users/DOB223/Library/CloudStorage/OneDrive-MedicalUniversityofSouthCarolina/Documents/lab/studies/1eeg/TNTanalysis/dataForStats/clean_covariates_2025-09-15.csv",
    na = c("Invalid Number", "invalid number", "INVALID NUMBER", "blank", "Blank", "BLANK", "")
)

# need to organize the newly imported data into long format to match the cmc_data
# remove pre-post and pre-fu variables before reshaping the data
motor_demog_data <- motor_demog_data %>%
    select(-matches("PRE-POST|PRE-FU", ignore.case = TRUE))

# reshape to long format
motor_demog_data_long <- motor_demog_data %>%
    pivot_longer(
        cols = -c(Subject, group, Sex, `TSS (month)`, `age (yr)`, race, `affected UE impacted?`),
        names_to = "metric",
        values_to = "value"
    )

# add new column descirbing timePoint for matching to cmc_data
motor_demog_data_long <- motor_demog_data_long %>%
    mutate(
        timePoint = case_when(
            grepl("pre", metric, ignore.case = TRUE) ~ "Pre",
            grepl("post", metric, ignore.case = TRUE) ~ "Post",
            grepl("FU", metric, ignore.case = TRUE) ~ "FU",
            TRUE ~ NA_character_
        ),
        metric = gsub("_Pre|_Post|_FU", "", metric, ignore.case = TRUE)
    )

# now, let's test the merger with one participant: TNT01
test_merge <- cmc_data %>% # var named test_merge from cmc_data
    filter(Subject == "TNT01") %>% # filter for one subject TNT01
    left_join( # left join with the motor_demog_data
        motor_demog_data %>% # with motor demog data
            filter(Subject == "TNT01"), # just by same subject TNT01
        by = c("Subject") # by subject ID
    )

# testing looks good. Now merge the full datasets
cmc_data_full <- cmc_data %>%
    left_join(
        motor_demog_data,
        by = c("Subject")
    )

### now, let's do some basic visualizations of the CMC data
# boxplot of CMC values by timePoint and frequencyBand
ggplot(cmc_data_full, aes(x = timePoint, y = PML, fill = Band)) +
    geom_boxplot() +
    theme_minimal() +
    labs(
        title = "CMC by Time Point and Frequency Band",
        x = "Time Point",
        y = "CMC - PML"
    ) +
    facet_wrap(~Muscle)

# line plot of CMC values over time for each subject, colored by frequencyBand
ggplot(cmc_data_full, aes(x = timePoint, y = PML, group = Subject, color = Band)) +
    geom_line() +
    geom_point() +
    theme_minimal() +
    labs(
        title = "CMC Over Time by Subject and Frequency Band",
        x = "Time Point",
        y = "CMC - PML"
    ) +
    facet_wrap(~Muscle)
