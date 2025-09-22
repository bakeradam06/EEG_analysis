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

# testing looks good. Now merge the full datasets
cmc_data_full <- cmc_data %>%
    left_join(
        motor_demog_data,
        by = c("Subject")
    )

################################################
########### descriptive statistics #############
################################################

# basic descriptives of cmc_data_full
summary(cmc_data_full)

# check for missing values
missing_values <- sapply(cmc_data_full, function(x) sum(is.na(x)))
print(missing_values)

# histogram of age and various other demographics
ggplot(cmc_data_full, aes(x = `age (yr)`)) + 
  geom_histogram()

# WMFT PRE
ggplot(distinct(cmc_data_full, Subject, .keep_all = TRUE), 
       aes(x = `WMFT PRE avg hand`)) + 
  geom_histogram(binwidth = 10) +
  labs(
    title = "Distribution of WMFT PRE Average Hand Scores",
    x = "WMFT PRE Average Hand Score",
    y = "Number of Subjects"
  )

# FMA UE PRE 
ggplot(distinct(cmc_data_full, Subject, .keep_all = TRUE), 
       aes(x = `FMA PRE total /66`)) + 
  geom_histogram(binwidth = 6) +
  labs(
    title = "Distribution of FMA PRE scores /66",
    x = "FMA PRE /66",
    y = "Number of Subjects"
  )
######################################################
### Histogram of the Pre CMC data across all subjects, according to connection
######################################################

# Pre, NoVib, Beta, Prep
ggplot(
    filter(cmc_data_full, timePoint == "Pre" & Condition == "NoVib" & Band == "Beta" & Phase == "Prep"), 
    aes(x = PML, fill = Muscle)
 ) +
    geom_histogram(binwidth = 0.01, position = "dodge") +
    labs(
        title = "Distribution of CMC values at Pre, NoVib, Beta, Prep",
        x = "CMC value",
        y = "count"
    )
# Pre, NoVib, Gamma, Prep
ggplot(
    filter(cmc_data_full, timePoint == "Pre" & Condition == "NoVib" & Band == "Gamma" & Phase == "Prep"), 
    aes(x = PML, fill = Muscle)
 ) +
    geom_histogram(binwidth = 0.01, position = "dodge") +
    labs(
        title = "Distribution of CMC values at Pre, NoVib, Gamma, Prep",
        x = "CMC value",
        y = "count"
    )

# Pre, Vib, Beta, Prep
ggplot(
    filter(cmc_data_full, timePoint == "Pre" & Condition == "Vib" & Band == "Beta" & Phase == "Prep"), 
    aes(x = PML, fill = Muscle)
 ) +
    geom_histogram(binwidth = 0.01, position = "dodge") +
    labs(
        title = "Distribution of CMC values at Pre, Vib, Beta, Prep",
        x = "CMC value",
        y = "count"
    )


# Pre, Vib, Gamma, Prep
ggplot(
    filter(cmc_data_full, timePoint == "Pre" & Condition == "Vib" & Band == "Gamma" & Phase == "Prep"), 
    aes(x = PML, fill = Muscle)
 ) +
    geom_histogram(binwidth = 0.01, position = "dodge") +
    labs(
        title = "Distribution of CMC values at Pre, Vib, Gamma, Prep",
        x = "CMC value",
        y = "count"
    )

# they all look pretty normally distributed so far

# Pre, NoVib, Beta, Exe
ggplot(
    filter(cmc_data_full, timePoint == "Pre" & Condition == "NoVib" & Band == "Beta" & Phase == "Exe"), 
    aes(x = PML, fill = Muscle)
 ) +
    geom_histogram(binwidth = 0.01, position = "dodge") +
    labs(
        title = "Distribution of CMC values at Pre, NoVib, Beta, Exe",
        x = "CMC value",
        y = "count"
    )

# Pre, NoVib, Gamma, Exe
ggplot(
    filter(cmc_data_full, timePoint == "Pre" & Condition == "NoVib" & Band == "Gamma" & Phase == "Exe"), 
    aes(x = PML, fill = Muscle)
 ) +
    geom_histogram(binwidth = 0.01, position = "dodge") +
    labs(
        title = "Distribution of CMC values at Pre, NoVib, Gamma, Exe",
        x = "CMC value",
        y = "count"
    )

# Pre, Vib, Beta, Exe
ggplot(
    filter(cmc_data_full, timePoint == "Pre" & Condition == "Vib" & Band == "Beta" & Phase == "Exe"), 
    aes(x = PML, fill = Muscle)
 ) +
    geom_histogram(binwidth = 0.01, position = "dodge") +
    labs(
        title = "Distribution of CMC values at Pre, Vib, Beta, Exe",
        x = "CMC value",
        y = "count"
    )

# Pre, Vib, Gamma, Exe
ggplot(
    filter(cmc_data_full, timePoint == "Pre" & Condition == "Vib" & Band == "Gamma" & Phase == "Exe"), 
    aes(x = PML, fill = Muscle)
 ) +
    geom_histogram(binwidth = 0.01, position = "dodge") +
    labs(
        title = "Distribution of CMC values at Pre, Vib, Gamma, Exe",
        x = "CMC value",
        y = "count"
    )

# still looks pretty normally distributed..

ks.test(cmc_data_full$M1L, "pnorm", mean = 0, sd = 1)
ggplot(cmc_data_full, aes(sample=M1N)) +
  geom_qq() + 
    geom_qq_line()
# ks test suggests none of the coh data are normally distributed, but the histograms and qq plots look at least alrgith


##### Boxplot #####
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

########

ggplot(cmc_data_full, aes(x = timePoint, y = M1N, color = Band)) +
  geom_violin()
  