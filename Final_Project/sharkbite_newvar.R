#project set up
library(tidyverse)
library(stringr)

##indicating files' location
# setwd("/Users/nataliebilal/Library/CloudStorage/OneDrive-Personal/R practice") 

sharkbite <- read.csv("data/sharkresights.csv") #access limited to research collaborators 

#selecting relevant variables
sharkbite_variables <- sharkbite %>% 
  select(animalID, season, date, area, regionID, markobs, obssex, obsage, comment, dead) 
View(sharkbite_variables) 

#remove cookie cutter false positives
sharkbite_nocookie <- sharkbite_variables %>% 
  filter(!str_detect(comment, 'cutter')) %>%
  filter(!str_detect(comment, 'CC')) %>%
  filter(!str_detect(comment, 'not shark'))

#categorical bite location variable
sharkbite_nocookie <- sharkbite_nocookie %>% 
  mutate(
    bite_location = case_when(
      str_detect(comment, 'flip|RF|FF') ~ "flipper",
      str_detect(comment, 'low|end|butt|rump|chin|eye|neck|face|mouth') ~ "end",
      TRUE ~ "body"
    )
  )
unique(sharkbite_nocookie$bite_location)

##note on mutate command: dataframe %>% mutate(new_variable = functions)

#categorical ageclass variable
sharkbite_nocookie <- sharkbite_nocookie %>% 
  mutate(
    age_binary = case_when(
      str_detect(obsage, 'ad|Ad') ~ "adult",
      TRUE ~ "juvenile"
    )
  )
unique(sharkbite_nocookie$age_binary)

#note to both to clean out point reyes observations