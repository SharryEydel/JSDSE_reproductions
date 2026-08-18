## ----setup, include=FALSE--------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, error = TRUE)
library(Lock5Data)
library(mosaic)
library(ggformula)


## --------------------------------------------------------------------------------------------------------------------
options(na.rm = TRUE)


## ----data-load-------------------------------------------------------------------------------------------------------
GSS <- read.csv("data/GSS_clean.csv")


## --------------------------------------------------------------------------------------------------------------------
GSS <- filter(GSS, should_marijuana_be_made_legal != "")
GSS <- filter(GSS, self_emp_or_works_for_somebody != "")


## --------------------------------------------------------------------------------------------------------------------
tally(should_marijuana_be_made_legal~self_emp_or_works_for_somebody, data = GSS, format = "proportion")
0.69-0.64


## --------------------------------------------------------------------------------------------------------------------
prop.test(should_marijuana_be_made_legal~self_emp_or_works_for_somebody, data = GSS,conf.level = 0.9)


## --------------------------------------------------------------------------------------------------------------------
prop.test(should_marijuana_be_made_legal~self_emp_or_works_for_somebody, data = GSS, alternative = "two.sided", success = "Legal")


## --------------------------------------------------------------------------------------------------------------------
mean(highest_year_of_school_completed~born_in_us, data=GSS)
12.85-13.97


## --------------------------------------------------------------------------------------------------------------------
t.test(highest_year_of_school_completed~born_in_us, data=GSS)


## --------------------------------------------------------------------------------------------------------------------
t.test(highest_year_of_school_completed~born_in_us, data=GSS,alternative="two.sided", mu = 0)


## --------------------------------------------------------------------------------------------------------------------
GSS <- transform(GSS, diff = highest_year_school_completed_father- highest_year_school_completed_mother)


## --------------------------------------------------------------------------------------------------------------------
mean(~diff, data = GSS)


## --------------------------------------------------------------------------------------------------------------------
t.test(~diff, data = GSS, alternative = "two.sided", mu = 0)

