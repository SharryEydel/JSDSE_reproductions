## ----setup, include=FALSE--------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, error = TRUE)
library(Lock5Data)
library(mosaic)
library(ggformula)


## ----data-load-------------------------------------------------------------------------------------------------------
GSS <- read.csv("data/GSS_clean.csv")


## --------------------------------------------------------------------------------------------------------------------
gf_histogram(~number_of_hours_worked_last_week, data = GSS)


## --------------------------------------------------------------------------------------------------------------------
gf_histogram(~number_of_hours_worked_last_week, data = GSS, binwidth = 10)


## --------------------------------------------------------------------------------------------------------------------
gf_histogram(~number_of_hours_worked_last_week, data = GSS, binwidth = 10) # change binwidth


## --------------------------------------------------------------------------------------------------------------------
gf_histogram(~number_of_brothers_and_sisters, data = GSS, binwidth = 1)


## --------------------------------------------------------------------------------------------------------------------
gf_density(~number_of_brothers_and_sisters, data = GSS)


## --------------------------------------------------------------------------------------------------------------------
gf_boxplot(~number_of_brothers_and_sisters, data = GSS)


## --------------------------------------------------------------------------------------------------------------------
gf_boxplot(marital_status~number_of_brothers_and_sisters, data = GSS)


## --------------------------------------------------------------------------------------------------------------------
gf_boxplot(number_of_hours_worked_last_week ~ factorize(marital_status), data = GSS)


## --------------------------------------------------------------------------------------------------------------------
mean(~number_of_hours_worked_last_week, data = GSS)


## --------------------------------------------------------------------------------------------------------------------
mean(~number_of_hours_worked_last_week, data = GSS, na.rm = TRUE)


## --------------------------------------------------------------------------------------------------------------------
median(~number_of_brothers_and_sisters, data = GSS, na.rm = TRUE)


## --------------------------------------------------------------------------------------------------------------------
fivenum(~number_of_hours_worked_last_week, data = GSS, na.rm = TRUE)
favstats(~number_of_hours_worked_last_week, data = GSS, na.rm = TRUE)

