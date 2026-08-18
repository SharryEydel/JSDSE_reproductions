## ----setup, include=FALSE--------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, error = TRUE)
library(Lock5Data)
library(tidyverse)
library(infer)


## ----data-load-------------------------------------------------------------------------------------------------------
GSS <- read_csv("data/GSS_clean.csv")


## --------------------------------------------------------------------------------------------------------------------
ggplot(GSS) + geom_boxplot(aes(x=marital_status, y=number_of_hours_worked_last_week))


## --------------------------------------------------------------------------------------------------------------------
GSS %>%
  drop_na(marital_status, number_of_hours_worked_last_week) %>%
  group_by(marital_status) %>%
  summarize(n = n())

GSS %>%
  drop_na(marital_status, number_of_hours_worked_last_week) %>%
  group_by(marital_status) %>%
  summarize(sd = sd(number_of_hours_worked_last_week))
16.7/13.7


## --------------------------------------------------------------------------------------------------------------------
a1 <- aov(number_of_hours_worked_last_week~marital_status, data = GSS)


## --------------------------------------------------------------------------------------------------------------------
summary(a1)


## --------------------------------------------------------------------------------------------------------------------
GSS %>%
  drop_na(marital_status, number_of_hours_worked_last_week) %>%
  group_by(marital_status) %>%
  summarize(n = n())

sqrt(208.6*(1/239+1/618))


## --------------------------------------------------------------------------------------------------------------------
TukeyHSD(a1, conf.level = 0.8)

