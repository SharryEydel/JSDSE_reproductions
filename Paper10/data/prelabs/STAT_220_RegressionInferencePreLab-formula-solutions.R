## ----setup, include=FALSE--------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, error = TRUE)
library(Lock5Data)
library(mosaic)
library(ggformula)


## ----data-load-------------------------------------------------------------------------------------------------------
GSS <- read.csv("data/GSS_clean.csv")


## --------------------------------------------------------------------------------------------------------------------
gf_point(highest_year_of_school_completed~highest_year_school_completed_spouse, data = GSS)


## --------------------------------------------------------------------------------------------------------------------
m1 <- lm(highest_year_of_school_completed~highest_year_school_completed_spouse, 
         data = GSS)
summary(m1)


## --------------------------------------------------------------------------------------------------------------------
summary(m1)


## --------------------------------------------------------------------------------------------------------------------
5.84740 + 0.59403 * 12


## --------------------------------------------------------------------------------------------------------------------
predict(m1, 
        newdata=data.frame(highest_year_school_completed_spouse = 12), 
        interval = "confidence")
predict(m1, 
        newdata=data.frame(highest_year_school_completed_spouse = 12), 
        interval = "prediction")


## --------------------------------------------------------------------------------------------------------------------
m2 <- lm(highest_year_of_school_completed~highest_year_school_completed_spouse+number_of_brothers_and_sisters,  data = GSS)

