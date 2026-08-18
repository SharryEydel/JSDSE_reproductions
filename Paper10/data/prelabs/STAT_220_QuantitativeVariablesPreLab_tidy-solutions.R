## ----setup, include=FALSE--------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, error = TRUE)
library(Lock5Data)
library(tidyverse)
library(infer)


## ----data-load-------------------------------------------------------------------------------------------------------
GSS <- read_csv("data/GSS_clean.csv")


## --------------------------------------------------------------------------------------------------------------------
ggplot(GSS)


## --------------------------------------------------------------------------------------------------------------------
ggplot(GSS) + geom_histogram(aes(x = number_of_hours_worked_last_week))


## --------------------------------------------------------------------------------------------------------------------
ggplot(GSS) + geom_histogram(aes(x = number_of_hours_worked_last_week), binwidth = 15)


## --------------------------------------------------------------------------------------------------------------------
ggplot(GSS) + geom_histogram(aes(x = number_of_hours_worked_last_week), binwidth = 15) # change binwidth


## --------------------------------------------------------------------------------------------------------------------
ggplot(GSS) + geom_histogram(aes(x = number_of_brothers_and_sisters), binwidth = 1)


## --------------------------------------------------------------------------------------------------------------------
ggplot(GSS) + geom_density(aes(x = number_of_brothers_and_sisters))


## --------------------------------------------------------------------------------------------------------------------
ggplot(GSS) + geom_boxplot(aes(y = number_of_brothers_and_sisters))


## --------------------------------------------------------------------------------------------------------------------
ggplot(GSS) + geom_boxplot(aes(y = number_of_hours_worked_last_week, x = marital_status))


## --------------------------------------------------------------------------------------------------------------------
ggplot(GSS) + geom_boxplot(aes(y = number_of_hours_worked_last_week,
                               x = as_factor(marital_status)))


## --------------------------------------------------------------------------------------------------------------------
GSS %>%
  summarize(mean(number_of_hours_worked_last_week))


## --------------------------------------------------------------------------------------------------------------------
GSS %>%
  summarize(mean_hours = mean(number_of_hours_worked_last_week))


## --------------------------------------------------------------------------------------------------------------------
GSS %>%
  drop_na(number_of_hours_worked_last_week) %>%
  summarize(mean_hours = mean(number_of_hours_worked_last_week))


## --------------------------------------------------------------------------------------------------------------------
GSS %>%
  drop_na(number_of_hours_worked_last_week) %>%
  summarize(median_siblings = median(number_of_brothers_and_sisters))


## --------------------------------------------------------------------------------------------------------------------
GSS %>%
  drop_na(number_of_hours_worked_last_week) %>%
  summarize(
    range = max(number_of_hours_worked_last_week) - min(number_of_hours_worked_last_week),
    IQR = IQR(number_of_hours_worked_last_week)
  )


## --------------------------------------------------------------------------------------------------------------------
GSS %>%
  drop_na(number_of_hours_worked_last_week) %>%
  summarize(
    min = min(number_of_hours_worked_last_week),
    lower_hinge = quantile(number_of_hours_worked_last_week, .25),
    median = median(number_of_hours_worked_last_week),
    upper_hinge = quantile(number_of_hours_worked_last_week, .75),
    max = max(number_of_hours_worked_last_week)
  )


## --------------------------------------------------------------------------------------------------------------------
GSS %>%
  pull(number_of_hours_worked_last_week) %>%
  fivenum()

