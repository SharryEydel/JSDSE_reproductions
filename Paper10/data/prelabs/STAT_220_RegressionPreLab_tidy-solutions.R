## ----setup, include=FALSE--------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, error = TRUE)
library(Lock5Data)
library(tidyverse)
library(infer)


## ----data-load-------------------------------------------------------------------------------------------------------
GSS <- read_csv("data/GSS_clean.csv")


## --------------------------------------------------------------------------------------------------------------------
ggplot(GSS) +
  geom_point(aes(x = highest_year_school_completed_spouse, y = highest_year_of_school_completed))


## --------------------------------------------------------------------------------------------------------------------
GSS %>%
  summarize(correlation = cor(y = highest_year_of_school_completed, 
                              x = highest_year_school_completed_spouse))


## --------------------------------------------------------------------------------------------------------------------
GSS %>%
  drop_na(highest_year_of_school_completed, highest_year_school_completed_spouse) %>%
  summarize(correlation = cor(
    y = highest_year_of_school_completed,
    x = highest_year_school_completed_spouse))


## --------------------------------------------------------------------------------------------------------------------
lm(highest_year_of_school_completed ~ highest_year_school_completed_spouse, data = GSS)


## --------------------------------------------------------------------------------------------------------------------
m1 <- lm(highest_year_of_school_completed ~ highest_year_school_completed_spouse, data = GSS)


## --------------------------------------------------------------------------------------------------------------------
m1 %>%
  summary()


## --------------------------------------------------------------------------------------------------------------------
5.847 + 0.594*12


## --------------------------------------------------------------------------------------------------------------------
5.847 + 0.594*12
15 - 12.975

