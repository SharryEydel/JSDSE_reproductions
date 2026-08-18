rm(list=ls())

library(Hmisc)
library(mvnormtest)
library(lavaan)
library(semTools)
library(performance)
library(car)
library(ggeffects)
library(ggplot2)
library(MuMIn)

# Sharry's code
# Need to install 'see' for 'check_model(fit.glm.1)'
library(see)
# Set random seed for reproduction
set.seed(220)

rev.score<-function(x) (max(x,na.rm=TRUE)+1)-x

#set appropriate working directory
#setwd("~/Documents")

#dataf=data.frame(read.csv("StatsTaskValuesData.csv",header=T,na.strings=""))
dataf=data.frame(readxl::read_xlsx("dataverse_files/StatsTaskValuesData.xlsx"))
names(dataf)
nrow(dataf)
#n=360

########################    Data Cleaning ##############################

#Make unique ID that accounts for each class section
#dataf<-dataf %>%
#  mutate(unique.section = paste(semester, school, sep = "-"))
#table(dataf$unique.section)
#Only 4 unique sections


#Reverse-score items
dataf$A2_2.rev<-rev.score(dataf$A2_2)
dataf$A2_5.rev<-rev.score(dataf$A2_5)


############################### Descriptive Stats for Items ##################

#make data set with just the value items
items<-dataf[,3:39]

#histograms of items
par(mfcol=c(7,6), oma=c(1,1,0,0), mar=c(1,1,1,0), tcl=-0.1, mgp=c(0,0,0))
hist.data.frame(items)
#some variables are skewed, some are not
#Definitely non-normality for some items
par(mfcol=c(1,1))

#Test for multivariate normality
items.mat<-as.matrix(items)
items.mat<-t(items.mat)
mshapiro.test(items.mat)
#p < 2.2 x 10^-16
#rejects the assumption of multivariate normality - must use a robust estimator in CFAs

#Item Means and SDs
colMeans(dataf[,3:39],na.rm=T)
sapply(dataf[,3:39],sd,na.rm=T)

#Item correlations - Appendix B, Table S1
options(max.print=999999)
cor(cbind(dataf[,3:39]))

################### Separate tests within constructs - following methods of Gaspard et al., 2015 ###############################


###########  Interest ###############################
#should only be one factor

int.model<-'Interest = ~I1_1 + I1_2 + I1_3 + I1_4'

fit.int<-cfa(int.model, data = dataf, estimator = "MLR")
summary(fit.int, fit.measures = TRUE, standardized = TRUE)

#Correlation residuals
resid(fit.int,type="cor")

##########  Attainment Value  ######################
#2 hypothesized factors according to Gaspard
#Gaspard correlated the residuals of the two negatively worded items

#Facets Model
attain.model.1<-'
Attain1 =~ A1_1 + A1_2 + A1_3 + A1_4
Attain2 =~ A2_1 + A2_2.rev + A2_3 + A2_4 + A2_5.rev + A2_6

#Correlate residuals of negatively worded items
A2_2.rev~~A2_5.rev'


#Single Construct
attain.model.2<-'
Attain =~ A1_1 + A1_2 + A1_3 + A1_4 + A2_1 + A2_2.rev + A2_3 + A2_4 + A2_5.rev + A2_6

#Correlate residuals of negatively worded items
A2_2.rev~~A2_5.rev'


fit.attain.1<-cfa(attain.model.1, data = dataf, estimator = "MLR")
summary(fit.attain.1, fit.measures = TRUE, standardized = TRUE)
resid(fit.attain.1,type="cor")


fit.attain.2<-cfa(attain.model.2, data = dataf, estimator = "MLR")
summary(fit.attain.2, fit.measures = TRUE, standardized = TRUE)



###############  Utility Value  ############################
#Only looking at U1 - U4

#Facets Model
uty.model.1<-'
Utility1 = ~U1_1 + U1_2
Utility2 = ~U2_1 + U2_2 + U2_3
Utility3 =~ U3_1 + U3_2 + U3_3
Utility4 = ~U4_1 + U4_2'

#Single Construct
uty.model.2<-'
Utility =~ U1_1 + U1_2 + U2_1 + U2_2 + U2_3 + U3_1 + U3_2 + U3_3 + U4_1 + U4_2'


fit.uty.1<-cfa(uty.model.1, data = dataf, estimator = "MLR")
summary(fit.uty.1, fit.measures = TRUE, standardized = TRUE)
resid(fit.uty.1,type="cor")

fit.uty.2<-cfa(uty.model.2, data = dataf, estimator = "MLR")
summary(fit.uty.2, fit.measures = TRUE, standardized = TRUE)



####################### Cost ###############################
#3 hypothesized facets

cost.model.1<-'
Cost1 = ~C1_1 + C1_2 + C1_3 + C1_4
Cost2 = ~C2_1 + C2_2 + C2_3 + C2_4
Cost3 =~ C3_1 + C3_2 + C3_3'

cost.model.2<-'
Cost = ~C1_1 + C1_2 + C1_3 + C1_4 + C2_1 + C2_2 + C2_3 + C2_4 + C3_1 + C3_2 + C3_3'


fit.cst.1<-cfa(cost.model.1, data = dataf, estimator = "MLR")
summary(fit.cst.1, fit.measures = TRUE, standardized = TRUE)
resid(fit.cst.1,type="cor")

fit.cst.2<-cfa(cost.model.2, data = dataf, estimator = "MLR")
summary(fit.cst.2, fit.measures = TRUE, standardized = TRUE)






############################   CFA on the ENTIRE Scale  ##########################################

facets.model<-'
Interest = ~I1_1 + I1_2 + I1_3 + I1_4
Attain1 =~ A1_1 + A1_2 + A1_3 + A1_4
Attain2 =~ A2_1 + A2_2.rev + A2_3 + A2_4 + A2_5.rev + A2_6
Utility1 = ~U1_1 + U1_2
Utility2 = ~U2_1 + U2_2 + U2_3
Utility3 = ~U3_1 + U3_2 + U3_3
Utility4 = ~U4_1 + U4_2
Cost1 = ~C1_1 + C1_2 + C1_3 + C1_4
Cost2 = ~C2_1 + C2_2 + C2_3 + C2_4
Cost3 = ~C3_1 + C3_2 + C3_3

#Correlate residuals of negatively worded items
A2_2.rev~~A2_5.rev'


values.model<-'
Interest = ~I1_1 + I1_2 + I1_3 + I1_4
Attain =~ A1_1 + A1_2 + A1_3 + A1_4 + A2_1 + A2_2.rev + A2_3 + A2_4 + A2_5.rev + A2_6
Utility = ~U1_1 + U1_2 + U2_1 + U2_2 + U2_3 + U3_1 + U3_2 + U3_3 + U4_1 + U4_2
Cost = ~C1_1 + C1_2 + C1_3 + C1_4 + C2_1 + C2_2 + C2_3 + C2_4 + C3_1 + C3_2 + C3_3

#Correlate residuals of negatively worded items
A2_2.rev~~A2_5.rev'


fit.facets<-cfa(facets.model, data = dataf, estimator = "MLR")
summary(fit.facets, fit.measures = TRUE, standardized = TRUE)
resid(fit.facets,type="cor")

fit.values<-cfa(values.model, data = dataf, estimator = "MLR")
summary(fit.values, fit.measures = TRUE, standardized = TRUE)



##############  Reliability on the measures   ############################

#omega
compRelSEM(fit.facets,tau.eq=FALSE,return.total=TRUE)





################################   Multiple Linear Regression (MLR) Analysis   ###########################################


##########  Data Cleaning for MLR  #########################

### Create a column for correct response to each of the 16 BioVEDA items from Hicks et al. (2020)
#Q5, Q7, Q14, and Q18 are not part of Hicks et al. final assessment - removed from analyses
#Binary column: 1 = correct; 0 = wrong
dataf$Q1.c<-ifelse(dataf$Q1==3,1,0)
dataf$Q2.c<-ifelse(dataf$Q2==3,1,0)
dataf$Q3.c<-ifelse(dataf$Q3MC==1,1,0)
dataf$Q4.c<-ifelse(dataf$Q4==2,1,0)
dataf$Q6.c<-ifelse(dataf$Q6==2,1,0)
dataf$Q8.c<-ifelse(dataf$Q8==1,1,0)
dataf$Q9.c<-ifelse(dataf$Q9==2,1,0)
dataf$Q10.c<-ifelse(dataf$Q10==1,1,0)
dataf$Q11.c<-ifelse(dataf$Q11==1,1,0)
dataf$Q12.c<-ifelse(dataf$Q12==1,1,0)
dataf$Q13.c<-ifelse(dataf$Q13==4,1,0)
dataf$Q15.c<-ifelse(dataf$Q15==4,1,0)
dataf$Q16.c<-ifelse(dataf$Q16MC==2,1,0)
dataf$Q17.c<-ifelse(dataf$Q17==4,1,0)
dataf$Q19.c<-ifelse(dataf$Q19==1,1,0)
dataf$Q20.c<-ifelse(dataf$Q20==3,1,0)

#Create a total BioVEDA score for each student by summing # of correct responses
dataf$BV<-rowSums(dataf[,c("Q1.c","Q2.c","Q3.c","Q4.c","Q6.c",
                           "Q8.c","Q9.c","Q10.c","Q11.c","Q12.c","Q13.c",
                           "Q15.c","Q16.c","Q17.c","Q19.c","Q20.c")])


#Create a total BioVEDA score for 14 items (short BioVEDA score)
#these are the items that all students did across all 4 semesters
#sum correct responses
dataf$BV.short<-rowSums(dataf[,c("Q1.c","Q2.c","Q4.c","Q6.c",
                                 "Q8.c","Q9.c","Q10.c","Q11.c","Q12.c","Q13.c",
                                 "Q15.c","Q17.c","Q19.c","Q20.c")])


##Are full BioVEDA scores (16 items) and short BioVEDA scores (14 items) correlated?
cor(dataf$BV,dataf$BV.short,use="complete.obs")
#cor=0.97
#yes, very high correlation - use total score for short BioVEDA (14 items) to increase sample size

#Histogram of BioVEDA short scores (14 items)
hist(dataf$BV.short,breaks=c(0.5,1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5,11.5,12.5,13.5,14.5))
summary(dataf$BV.short)
#approximately a normal distribution
#range is 1-14 out of 14 possible; most students score between 5-9

#Mean and SD of BioVEDA short items
mean(dataf$BV.short,na.rm=T)
sd(dataf$BV.short,na.rm=T)



####### Create subset containing complete data for MLR #############

#Data set with complete values for short BV only
dataf.4<-subset(dataf,!is.na(BV.short))
#n = 263




############  Sensitivity Analysis: Re-run CFA with subsetted data  ##########

subset.model<-'
Interest = ~I1_1 + I1_2 + I1_3 + I1_4
Attain1 =~ A1_1 + A1_2 + A1_3 + A1_4
Attain2 =~ A2_1 + A2_2.rev + A2_3 + A2_4 + A2_5.rev + A2_6
Utility1 = ~U1_1 + U1_2
Utility2 = ~U2_1 + U2_2 + U2_3
Utility3 =~ U3_1 + U3_2 + U3_3
Utility4 = ~U4_1 + U4_2
Cost1 = ~C1_1 + C1_2 + C1_3 + C1_4
Cost2 = ~C2_1 + C2_2 + C2_3 + C2_4
Cost3 =~ C3_1 + C3_2 + C3_3

#Correlate residuals of negatively worded items
A2_2.rev~~A2_5.rev
'

fit.subset<-cfa(subset.model,data=dataf.4,estimator="MLR")
summary(fit.subset,fit.measures=T,standardized=T, rsquare=T)
#n=263






################  MLR  #########################

#Create composite scores for each task-value facet by taking the means of the items
dataf.4$Int<-rowMeans(dataf.4[,c("I1_1","I1_2","I1_3","I1_4")])
dataf.4$AttImpAch<-rowMeans(dataf.4[,c("A1_1","A1_2","A1_3","A1_4")])
dataf.4$AttPersImp<-rowMeans(dataf.4[,c("A2_1","A2_2.rev","A2_3","A2_4","A2_5.rev","A2_6")])
dataf.4$UtySch<-rowMeans(dataf.4[,c("U1_1","U1_2")])
dataf.4$UtyDL<-rowMeans(dataf.4[,c("U2_1","U2_2","U2_3")])
dataf.4$UtySoc<-rowMeans(dataf.4[,c("U3_1","U3_2","U3_3")])
dataf.4$UtyJob<-rowMeans(dataf.4[,c("U4_1","U4_2")])
dataf.4$CstEff<-rowMeans(dataf.4[,c("C1_1","C1_2","C1_3","C1_4")])
dataf.4$CstEmo<-rowMeans(dataf.4[,c("C2_1","C2_2","C2_3","C2_4")])
dataf.4$CstOpp<-rowMeans(dataf.4[,c("C3_1","C3_2","C3_3")])

#Check correlations of task-value facets to get a sense of whether multicollinearity might be an issue
#Also to see raw correlations between task values and BioVEDA scores
cor(cbind(dataf.4$Int,dataf.4$AttImpAch,dataf.4$AttPersImp,dataf.4$UtySch,dataf.4$UtyDL,
          dataf.4$UtySoc,dataf.4$UtyJob,dataf.4$CstEff,dataf.4$CstEmo,dataf.4$CstOpp,dataf.4$BV.short))
#only correlations above 0.7: Effort Cost & Emotional Cost



#Make semester a categorical variable with the first semester as the reference semester
dataf.4$semester<-relevel(factor(dataf.4$semester),ref="1")

#Fit a regression model
fit.glm.1<-lm(BV.short ~ Int + AttImpAch + AttPersImp + UtySch + UtyDL + UtySoc + UtyJob + CstEff + CstEmo + CstOpp + semester, data=dataf.4)
summary(fit.glm.1)
#overall regression model is significant (p < 0.001) with adjusted R2 of 0.127
#of the task values, only Emotional cost is significant

#Check assumptions of MLR
plot(fit.glm.1)
#it actually looks good...
check_model(fit.glm.1)
#looks good using this package, too!

#Calculate the variance inflation factor to look for multicollinearity issues
fit.vif<-vif(fit.glm.1)
fit.vif
#square GVIF^(1/(2*df)) to get values analogous to traditional VIFs
sq.GVIF<-fit.vif[,3]^2
sq.GVIF





######### Model Selection of All Possible Nested Regression Models #########

#run overall model to see what comes out "best"
fit.glm.dredge<-lm(BV.short ~ Int + AttImpAch + AttPersImp + UtySch + UtyDL + UtySoc + UtyJob + CstEff + CstEmo + CstOpp + semester, data=dataf.4, na.action = "na.fail")
dd<-dredge(fit.glm.dredge,fixed="semester")
head(dd,n=10)

#Run regression of the "best" model
fit.glm.2<-lm(BV.short ~ AttImpAch + CstEmo + semester, data=dataf.4)
summary(fit.glm.2)

#Check assumptions of MLR
plot(fit.glm.2)
#it actually looks good...
check_model(fit.glm.2)
#looks good using this package, too!

#Calculate the variance inflation factor to look for multicollinearity issues
fit.vif.2<-vif(fit.glm.2)
fit.vif.2
#square GVIF^(1/(2*df)) to get values analogous to traditional VIFs
sq.GVIF.2<-fit.vif.2[,3]^2
sq.GVIF.2


####  Get AICc values to two decimal places for each of the best models

fit.AIC.1<-lm(BV.short ~ AttImpAch + CstEmo + semester, data=dataf.4)
fit.AIC.2<-lm(BV.short ~ AttImpAch + AttPersImp + CstEmo + semester, data=dataf.4)
fit.AIC.3<-lm(BV.short ~ AttImpAch + CstEmo + CstEff + semester, data=dataf.4)
fit.AIC.4<-lm(BV.short ~ AttImpAch + CstEmo + UtyJob + semester, data=dataf.4)
fit.AIC.5<-lm(BV.short ~ AttImpAch + CstEmo + UtyDL + semester, data=dataf.4)
fit.AIC.6<-lm(BV.short ~ AttImpAch + CstEmo + UtySch + semester, data=dataf.4)

AICc(fit.AIC.1,fit.AIC.2,fit.AIC.3,fit.AIC.4,fit.AIC.5,fit.AIC.6)



#---------------------------Sharry's Code -----------------------------------------------------------
# Reproductions -----------------------------------------------------------------------

####################### Table 2 ######################################################
## Get Means and Standard deviations
means <- colMeans(dataf[, 3:39], na.rm = TRUE)
sds   <- sapply(dataf[, 3:39], sd, na.rm = TRUE)

desc_table <- data.frame(
  Item = names(means),
  Mean = round(means, 2),
  SD   = round(sds, 2)
)

# desc_table$SD <- sprintf("%.2f", as.numeric(desc_table$SD))

## Get individual factor loadings
get_loadings <- function(model) {
  subset(standardizedSolution(model), op == "=~")[, c("rhs", "est.std")]
}

load_int    <- get_loadings(fit.int)
load_attain <- get_loadings(fit.attain.1)
load_uty    <- get_loadings(fit.uty.1)
load_cost   <- get_loadings(fit.cst.1)

indiv_loadings <- rbind(load_int, load_attain, load_uty, load_cost)
colnames(indiv_loadings) <- c("Item", "Loading_Individual")
indiv_loadings$Loading_Individual <- round(indiv_loadings$Loading_Individual, 2)

## Get combined factor loadings
std_combined <- standardizedSolution(fit.facets)
combined_loadings <- subset(std_combined, op == "=~")[, c("rhs", "est.std")]

colnames(combined_loadings) <- c("Item", "Loading_Combined")
combined_loadings$Loading_Combined <- round(combined_loadings$Loading_Combined, 2)

## Remove .rev from A2_2 and A2_5
indiv_loadings$Item <- sub("\\.rev$", "", indiv_loadings$Item)
combined_loadings$Item <- sub("\\.rev$", "", combined_loadings$Item)

## Merge to table2_compare
table2 <- merge(desc_table, indiv_loadings, by = "Item", sort = FALSE)
table2 <- merge(table2, combined_loadings, by = "Item", sort = FALSE)


## Format outputs:
table2_formatted <- table2
numeric_cols <- sapply(table2_formatted, is.numeric)

table2_formatted[numeric_cols] <- 
  lapply(table2_formatted[numeric_cols], 
         function(x) sprintf("%.2f", x))


####################### Table 3 ######################################################
## Get fits
get_fit <- function(model) {
  fm <- fitMeasures(model)
  c(
    chisq  = fm["chisq.scaled"],
    df     = fm["df.scaled"],
    pvalue = fm["pvalue.scaled"],
    cfi    = fm["cfi.robust"],
    tli    = fm["tli.robust"],
    rmsea  = fm["rmsea.robust"],
    srmr   = fm["srmr"]
  )
}

table3 <- rbind(
  Intrinsic        = get_fit(fit.int),
  Attain_Facets2   = get_fit(fit.attain.1),
  Attain_Single    = get_fit(fit.attain.2),
  Utility_Facets4  = get_fit(fit.uty.1),
  Utility_Single   = get_fit(fit.uty.2),
  Cost_Facets3     = get_fit(fit.cst.1),
  Cost_Single      = get_fit(fit.cst.2),
  Facets10         = get_fit(fit.facets),
  Facets_Value     = get_fit(fit.values)
)

table3 <- as.data.frame(table3)
colnames(table3) <- c(
  "χ² (scaled)",
  "df",
  "p-value",
  "CFI (robust)",
  "TLI (robust)",
  "RMSEA (robust)",
  "SRMR"
)

# Make values less than 0.001 in table equal to 0.001
table3$`p-value`[table3$`p-value` < .001] = 0.001

## Format like table
table3_print <- table3

### Set df to integers
table3_print$df <- as.integer(round(table3_print$df))

### Make everything else 2 decimal points
other_cols <- setdiff(
  names(table3_print),
  c("df", "p-value")
)

table3_print[other_cols] <-
  lapply(table3_print[other_cols],
         function(x) sprintf("%.2f", x))

### Set p-value to 3 decimal points
table3_print$`p-value` <- ifelse(
  table3_print$`p-value` < .001,
  0.001,
  ifelse(
    table3_print$'p-value' < 0.1,
    format(round(table3_print$'p-value', 3), nsmall=3),
    format(round(table3_print$'p-value', 2), nsmall=2)
  )
)


####################### Table 4 ######################################################
cor_matrix <- lavInspect(fit.facets, "cor.lv") # Get correlations
cor_matrix <- round(cor_matrix, 2)             # Round it
diag(cor_matrix) <- NA                         # Turn 1's into NA
table4 <- as.data.frame(cor_matrix)            # Convert to data frame
table4[upper.tri(table4)] <- NA                # Makes upper triangle blank

## Add omega row
omega_vals <- compRelSEM(fit.facets,tau.eq=FALSE)
length(omega_vals)
omega_vals <- round(omega_vals, 2)
table4 <- rbind(table4, Omega = omega_vals)
table4

####################### Table 5 ######################################################
# Get coefficient data
table5 <- as.data.frame(summary(fit.glm.1)$coefficients)
table5 <- table5[-1, -3] # Remove (Intercept) row (row 1) and "t value" column (col 3)

# Rename columns
colnames(table5) <- c("Regression coefficient",
                      "SE",
                      "p-value")

# Format 2 decimal points
table5 <- round(table5, 2)
table5

####################### Table 6 ######################################################
table6 <- as.data.frame(AICc(fit.AIC.1,fit.AIC.2,fit.AIC.3,fit.AIC.4,fit.AIC.5,fit.AIC.6)) # Get AICc's
table6 <- table6[,-1] # Remove df column

# Format
table6 <- round(table6, 2)
table6

# Comparisons ---------------------------------------------------------------------------
############################# Make comparison tables ##################################

# Turn Standard deviation into num.
table2$SD <- as.numeric(table2$SD)
table2 <- table2[,-1]

# Copy the tables I made to avoid formatting issues (table 6 is a vector, no formatting needed)
table2_paper <- table2
table3_paper <- table3
table4_paper <- table4
table5_paper <- table5

# Changing values for paper tables
## Table 2
table2_paper[,1] = c(
  3.97,4.13,3.96,4.18,
  5.44,4.84,5.71,6.10,
  5.17,3.06,4.46,3.89,3.46,4.75,
  5.63,5.46,
  4.65,4.09,4.53,
  4.81,4.14,4.29,
  5.71,5.84,
  4.21,3.97,3.97,3.94,
  3.13,3.94,3.23,3.23,
  3.15,2.88,3.29
)

table2_paper[,2] = c(
  1.55,1.56,1.53,1.54,
  1.22,1.37,1.18,0.93,
  1.24,1.46,1.34,1.48,1.60,1.29,
  1.26,1.28,
  1.52,1.54,1.55,
  1.20,1.52,1.37,
  1.13,1.15,
  1.55,1.62,1.64,1.64,
  1.42,1.59,1.49,1.59,
  1.66,1.51,1.73
)

table2_paper[,3] = c(
  0.94,0.96,0.90,0.80,
  0.85,0.90,0.64,0.32,
  0.73,0.60,0.84,0.78,0.75,0.73,
  0.98,0.71,
  0.88,0.94,0.83,
  0.69,0.85,0.90,
  0.57,0.84,
  0.91,0.96,0.96,0.93,
  0.82,0.78,0.90,0.78,
  0.87,0.95,0.88
)

table2_paper[,4] = c(
  0.94,0.96,0.90,0.81,
  0.85,0.89,0.65,0.33,
  0.72,0.63,0.84,0.77,0.78,0.71,
  0.99,0.70,
  0.89,0.93,0.83,
  0.70,0.86,0.89,
  0.55,0.86,
  0.91,0.96,0.96,0.93,
  0.83,0.79,0.90,0.76,
  0.87,0.95,0.88
)
table2_paper
table2

## Table 3
table3_paper[,1]  <- c(1.39,141.10,232.13,56.66,570.67,121.40,675.73,1106.92,2732.29)
table3_paper[,2]     <- c(2,33,34,29,35,41,44,514,553)
table3_paper[,3] <- c(0.50,0.001,0.001,0.001,0.001,0.001,0.001,0.001,0.001)
table3_paper[,4]    <- c(1.00,0.92,0.86,0.98,0.61,0.97,0.75,0.93,0.75)
table3_paper[,5]    <- c(1.00,0.90,0.81,0.97,0.50,0.96,0.69,0.92,0.73)
table3_paper[,6]  <- c(0.00,0.11,0.15,0.06,0.25,0.09,0.25,0.06,0.12)
table3_paper[,7]   <- c(0.01,0.07,0.08,0.04,0.15,0.03,0.12,0.06,0.10)

table3_paper
table3_print

## Table 4
# Fill lower triangle from paper

table4_paper[2,1]  <- 0.54

table4_paper[3,1]  <- 0.76
table4_paper[3,2]  <- 0.80

table4_paper[4,1]  <- 0.36
table4_paper[4,2]  <- 0.56
table4_paper[4,3]  <- 0.54

table4_paper[5,1]  <- 0.51
table4_paper[5,2]  <- 0.48
table4_paper[5,3]  <- 0.67
table4_paper[5,4]  <- 0.40

table4_paper[6,1]  <- 0.38
table4_paper[6,2]  <- 0.43
table4_paper[6,3]  <- 0.51
table4_paper[6,4]  <- 0.37
table4_paper[6,5]  <- 0.54

table4_paper[7,1]  <- 0.40
table4_paper[7,2]  <- 0.68
table4_paper[7,3]  <- 0.63
table4_paper[7,4]  <- 0.73
table4_paper[7,5]  <- 0.45
table4_paper[7,6]  <- 0.40

table4_paper[8,1]  <- -0.44
table4_paper[8,2]  <- -0.16
table4_paper[8,3]  <- -0.32
table4_paper[8,4]  <- -0.09
table4_paper[8,5]  <- -0.16
table4_paper[8,6]  <- -0.15
table4_paper[8,7]  <- -0.07

table4_paper[9,1]  <- -0.59
table4_paper[9,2]  <- -0.31
table4_paper[9,3]  <- -0.54
table4_paper[9,4]  <- -0.23
table4_paper[9,5]  <- -0.35
table4_paper[9,6]  <- -0.25
table4_paper[9,7]  <- -0.27
table4_paper[9,8]  <- 0.76

table4_paper[10,1] <- -0.32
table4_paper[10,2] <- -0.11
table4_paper[10,3] <- -0.17
table4_paper[10,4] <- -0.06
table4_paper[10,5] <- -0.13
table4_paper[10,6] <- -0.02
table4_paper[10,7] <- -0.06
table4_paper[10,8] <- 0.63
table4_paper[10,9] <- 0.64

table4_paper[11,] <- c(
  0.95,  # Intrinsic
  0.80,  # Attain_Achieve
  0.88,  # Attain_Personal
  0.84,  # Utility_School
  0.91,  # Utility_Daily
  0.87,  # Utility_Social
  0.68,  # Utility_Career
  0.97,  # Cost_Effort
  0.89,  # Cost_Emo
  0.93   # Cost_Opp
)
table4_paper

## Table 5
table5_paper[,1] = c(-0.01, 0.30, 0.30, -0.12, -0.13, -0.02, 0.17, 0.11, -0.52, -0.07, -0.30, -0.20, -0.90)
table5_paper[,2] = c(0.15, 0.24, 0.24, 0.17, 0.15, 0.15, 0.21, 0.15, 0.20, 0.13, 0.36, 0.51, 0.44)
table5_paper[,3] = c(0.96, 0.21, 0.21, 0.49, 0.39, 0.87, 0.41, 0.47, 0.01, 0.61, 0.40, 0.69, 0.04)

table5_paper
table5

## Table 6
table6_paper <- c(
  1193.09,
  1194.64,
  1194.77,
  1194.89,
  1195.00,
  1195.05
)

table6_paper
table6

# Compare tables
## Table 2
my_table2_means <- colMeans(table2[sapply(table2, is.numeric)], na.rm = TRUE)
paper_table2_means <- colMeans(table2_paper)
table2_compare <- data.frame(
  paper_means = paper_table2_means,
  my_means = my_table2_means,
  difference = c(paper_table2_means - my_table2_means)
)
table2_compare


## Table 3
my_table3_means <- colMeans(table3, na.rm = TRUE)
paper_table3_means <- colMeans(table3_paper, na.rm = TRUE)
table3_compare <- data.frame(
  paper_means = paper_table3_means,
  my_means = my_table3_means,
  difference = c(paper_table3_means - my_table3_means)
)
# Round to nearest 3 decimal points
table3_compare <- data.frame(lapply(table3_compare, function(x) {
  if (is.numeric(x)) round(x, 3) else x
}))
table3_compare

## Table 4
my_table4 <- table4[lower.tri(table4)]
paper_table4 <- table4_paper[lower.tri(table4_paper)]

table4_mad <- mean(abs(my_table4 - paper_table4), na.rm = TRUE)
mean(my_table4)
mean(paper_table4)
table4_mad

## Table 5
my_table5_means <- colMeans(table5)
paper_table5_means <- colMeans(table5_paper)
table5_compare <- data.frame(
  paper_means = paper_table5_means,
  my_means = my_table5_means,
  difference = c(paper_table5_means - my_table5_means)
)
table5_compare

## Table 6
table6_compare <- data.frame(
  paper_table6 = table6_paper,
  my_table6 = table6,
  difference = c(table6_paper - table6)
)

## Final look at comparison tables
table2_compare
table3_compare
table4_mad
table5_compare
table6_compare
colMeans(table6_compare)

# Document my environment
sessionInfo()