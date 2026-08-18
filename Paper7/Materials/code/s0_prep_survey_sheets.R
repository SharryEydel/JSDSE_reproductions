# PURPOSE: Read in and process the survey excel sheets 

library(tidyverse)
library(readxl)

read_excel_sheets <- function(filename) {
  
  sheets <- excel_sheets(filename)
  x <- lapply(sheets, function(X) read_excel(filename, sheet = X))
  names(x) <- sheets
  x
  
}


# Load in the full excel file ---------------------------------------------

raw_survey_sheets <- read_excel_sheets("Paper2/Materials/data/survey data/DataVisualizationClassSurvey.xlsx")

# Inspect the sheets
head(raw_survey_sheets$Universities)

# Clean names and save single csv -----------------------------------------

# First separate and clean the column names, then add label for file type:
univ_survey <- raw_survey_sheets$Universities |>
  janitor::clean_names() |>
  mutate(type = "university") |>
  # Drop the notes columns:
  dplyr::select(-contains("notes"))

# Repeat for liberal arts:
lib_arts_survey <- raw_survey_sheets$`Liberal Arts Colleges` |>
  janitor::clean_names() |>
  mutate(type = "liberal_arts") |>
  # Drop the notes columns:
  dplyr::select(-contains("notes"))

# Stack and save:
clean_survey_file <- univ_survey |>
  bind_rows(lib_arts_survey)

write_csv(clean_survey_file, "Paper2/materials/data/survey data/my_survey_results.csv")


