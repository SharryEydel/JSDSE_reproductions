## ----setup, include=FALSE--------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, error = TRUE)
library(Lock5Data)
library(tidyverse)
library(infer)
set.seed(42)


## ----data-load-------------------------------------------------------------------------------------------------------
GSS <- read_csv("../../data/GSS_clean.csv")


## --------------------------------------------------------------------------------------------------------------------
GSS <- GSS %>%
  drop_na(highest_year_of_school_completed)


## --------------------------------------------------------------------------------------------------------------------
ggplot(GSS) + geom_histogram(aes(x=highest_year_of_school_completed), binwidth = 2)


## --------------------------------------------------------------------------------------------------------------------
GSS %>%
  summarize(mean = mean(highest_year_of_school_completed))


## --------------------------------------------------------------------------------------------------------------------
bootstrap_sample <- GSS %>%
  specify(response = highest_year_of_school_completed) %>%
  generate(reps = 1, type = "bootstrap") 


## --------------------------------------------------------------------------------------------------------------------
ggplot(bootstrap_sample) + geom_histogram(aes(x= highest_year_of_school_completed), binwidth = 2)


## --------------------------------------------------------------------------------------------------------------------
set.seed(42)


## --------------------------------------------------------------------------------------------------------------------
set.seed(42)
bootstrap_sample <- GSS %>%
  specify(response = highest_year_of_school_completed) %>%
  generate(reps = 1, type = "bootstrap") 
ggplot(bootstrap_sample) + geom_histogram(aes(x=highest_year_of_school_completed), binwidth = 2)
bootstrap_sample <- GSS %>%
  specify(response = highest_year_of_school_completed) %>%
  generate(reps = 1, type = "bootstrap") 
ggplot(bootstrap_sample) + geom_histogram(aes(x=highest_year_of_school_completed), binwidth = 2)
set.seed(42)
bootstrap_sample <- GSS %>%
  specify(response = highest_year_of_school_completed) %>%
  generate(reps = 1, type = "bootstrap") 
ggplot(bootstrap_sample) + geom_histogram(aes(x=highest_year_of_school_completed), binwidth = 2)


## --------------------------------------------------------------------------------------------------------------------
boot <- GSS %>%
  specify(response = highest_year_of_school_completed) %>%
  generate(reps = 1000, type = "bootstrap") %>%
  calculate(stat = "mean")


## --------------------------------------------------------------------------------------------------------------------
ggplot(boot) + geom_histogram(aes(x=stat), binwidth=0.02)


## --------------------------------------------------------------------------------------------------------------------
boot %>%
  summarize(mean(stat))


## --------------------------------------------------------------------------------------------------------------------
get_ci(boot)

