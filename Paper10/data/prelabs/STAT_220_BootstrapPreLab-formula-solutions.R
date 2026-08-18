## ----setup, include=FALSE--------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, error = TRUE)
library(Lock5Data)
library(mosaic)
library(ggformula)
options(na.rm = TRUE)


## ----data-load-------------------------------------------------------------------------------------------------------
GSS <- read.csv("data/GSS_clean.csv")


## --------------------------------------------------------------------------------------------------------------------
gf_histogram(~highest_year_of_school_completed, data=GSS, binwidth = 2)


## --------------------------------------------------------------------------------------------------------------------
mean(~highest_year_of_school_completed, data=GSS)


## --------------------------------------------------------------------------------------------------------------------
resample(GSS)


## --------------------------------------------------------------------------------------------------------------------
bootstrap_sample <- do(1) * resample(GSS)


## --------------------------------------------------------------------------------------------------------------------
gf_histogram(~highest_year_of_school_completed, data = bootstrap_sample, binwidth = 2)


## --------------------------------------------------------------------------------------------------------------------
set.seed(42)


## --------------------------------------------------------------------------------------------------------------------
set.seed(42)
bootstrap_sample <- do(1) * resample(GSS)
gf_histogram(~highest_year_of_school_completed, data = bootstrap_sample, binwidth = 2)
bootstrap_sample <- do(1) * resample(GSS)
gf_histogram(~highest_year_of_school_completed, data = bootstrap_sample, binwidth = 2)
set.seed(42)
bootstrap_sample <- do(1) * resample(GSS)
gf_histogram(~highest_year_of_school_completed, data = bootstrap_sample, binwidth = 2)


## --------------------------------------------------------------------------------------------------------------------
boot <- do(1000) * mean(~highest_year_of_school_completed, data = resample(GSS))


## --------------------------------------------------------------------------------------------------------------------
gf_histogram(~mean, data = boot)


## --------------------------------------------------------------------------------------------------------------------
mean(~mean, data = boot)


## --------------------------------------------------------------------------------------------------------------------
confint(boot)

