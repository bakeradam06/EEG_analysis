# EEG analysis

# Taking step9 excel files and organizing them together to visualize and run statistics, or at least prepare to do so. Ramesh might end up doing the stats.

#########

## load libraries
library(readxl) # for reading excel files
library(dplyr) # for data manipulation
library(tidyr) # for data tidying, reshaping
library(purrr) # for functional programming, working with lists
library(stringr) # for string manipulation
library(janitor) # for data cleaning
library(ggplot2) # for visualization

########

# create loop for reading in all files in a directory
# set working directory to folder with all step9 excel files
setwd("/Users/DOB223/Library/CloudStorage/OneDrive-MedicalUniversityofSouthCarolina/Documents/lab/studies/1eeg/TNTanalysis/step9excel")

# get list of all excel files in the directory (they all should have file extension .xlsm)
file_list <- list.files(pattern = "*.xlsm")

# create function to loop through all excels and organize data into respective parts
read_and_organize <- function(file_path) {
    # get all sheets in excel file # nolint: indentation_linter.
    sheets <- excel_sheets(file_path)

    # read & process each sheet
}
