## ----setup, include=FALSE--------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, error = TRUE)
library(Lock5Data)
library(tidyverse)
library(infer)


## ----data-load-------------------------------------------------------------------------------------------------------
GSS <- read_csv("data/GSS_clean.csv")


## --------------------------------------------------------------------------------------------------------------------
GSS <- GSS %>%
  drop_na(number_of_hours_worked_last_week)


## --------------------------------------------------------------------------------------------------------------------
GSS %>%
  summarize(mean(number_of_hours_worked_last_week))


## --------------------------------------------------------------------------------------------------------------------
GSS %>%
  t_test(response = number_of_hours_worked_last_week, 
         alternative = "two-sided", mu = 40)


## --------------------------------------------------------------------------------------------------------------------
GSS %>% 
  t_test(response = number_of_hours_worked_last_week, 
         conf_int = TRUE)


## --------------------------------------------------------------------------------------------------------------------
GSS %>%
  summarize(
    mean = mean(number_of_hours_worked_last_week),
    sd = sd(number_of_hours_worked_last_week),
    n = n()
  ) %>%
  mutate(se = sd / sqrt(n)) 


## --------------------------------------------------------------------------------------------------------------------
GSS %>%
  summarize(
    mean = mean(number_of_hours_worked_last_week),
    sd = sd(number_of_hours_worked_last_week),
    n = n()
  ) %>%
  mutate(se = sd / sqrt(n)) %>%
  mutate(t_stat = (mean - 40) / se) %>%
  mutate(pvalue = 2 * pt(t_stat, df = n - 1, lower.tail = FALSE))


## --------------------------------------------------------------------------------------------------------------------
GSS %>%
  summarize(
    mean = mean(number_of_hours_worked_last_week),
    sd = sd(number_of_hours_worked_last_week),
    n = n()
  ) %>%
  mutate(
    se = sd / sqrt(n),
    critical_t = qt(0.975, df = 1380),
    me = critical_t * se
  ) %>%
  mutate(low = mean - me, high = mean + me)


## --------------------------------------------------------------------------------------------------------------------
qt(0.975, df = 1380)

