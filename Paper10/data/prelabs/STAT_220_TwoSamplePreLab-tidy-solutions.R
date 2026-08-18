## ----setup, include=FALSE--------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, error = TRUE)
library(Lock5Data)
library(tidyverse)
library(infer)


## ----data-load-------------------------------------------------------------------------------------------------------
GSS <- read_csv("data/GSS_clean.csv")


## --------------------------------------------------------------------------------------------------------------------
GSS %>%
  drop_na(self_emp_or_works_for_somebody, should_marijuana_be_made_legal) %>%
  group_by(should_marijuana_be_made_legal, self_emp_or_works_for_somebody) %>%
  summarize(n = n()) %>%
  mutate(prop = n/sum(n))
0.647-0.69


## --------------------------------------------------------------------------------------------------------------------
GSS %>%
  prop_test(response = should_marijuana_be_made_legal, 
            explanatory = self_emp_or_works_for_somebody, 
            alternative = "two-sided", order = c("Self-employed", "Someone else"))


## --------------------------------------------------------------------------------------------------------------------
GSS %>%
  prop_test(response = should_marijuana_be_made_legal, 
            explanatory = self_emp_or_works_for_somebody, 
            alternative = "two-sided", order = c("Self-employed", "Someone else"))


## --------------------------------------------------------------------------------------------------------------------
GSS %>%
  prop_test(response = should_marijuana_be_made_legal, 
            explanatory = self_emp_or_works_for_somebody, 
            order = c("Self-employed", "Someone else"))


## --------------------------------------------------------------------------------------------------------------------
GSS %>%
  prop_test(response = should_marijuana_be_made_legal, 
            explanatory = self_emp_or_works_for_somebody, 
            order = c("Self-employed", "Someone else"), conf_level = 0.95)


## --------------------------------------------------------------------------------------------------------------------
GSS %>%
  drop_na(born_in_us, highest_year_of_school_completed) %>%
  group_by(born_in_us) %>%
  summarize(mean(highest_year_of_school_completed))
12.7-13.9


## --------------------------------------------------------------------------------------------------------------------
GSS %>%
  t_test(response = highest_year_of_school_completed, 
         explanatory = born_in_us, 
         alternative = "two-sided")


## --------------------------------------------------------------------------------------------------------------------
GSS %>%
  t_test(response = highest_year_of_school_completed, 
         explanatory = born_in_us, 
         alternative = "two-sided", order = c("No", "Yes"))


## --------------------------------------------------------------------------------------------------------------------
GSS %>%
  t_test(response = highest_year_of_school_completed, 
         explanatory = born_in_us, 
         order = c("No", "Yes"))


## --------------------------------------------------------------------------------------------------------------------
GSS <- GSS %>%
  mutate(diff = highest_year_school_completed_father - highest_year_school_completed_mother)


## --------------------------------------------------------------------------------------------------------------------
GSS %>%
  drop_na(diff) %>%
  summarize(mean = mean(diff))


## --------------------------------------------------------------------------------------------------------------------
GSS %>%
  t_test(response = diff, 
         alternative = "two-sided", mu = 0)

