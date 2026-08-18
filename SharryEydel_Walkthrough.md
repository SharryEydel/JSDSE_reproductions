

# Paper Reproduction Walkthrough Template

## Part 1: Initial Paper Scan

### 1.1 Basic Information
| Field | Information |
|-------|-------------|
| **Title** | Examining Motivational Attitudes Toward Statistics and Their Relationship to Performance in Life Science Students |
| **Authors** | Alexander R. Kulacki and Melissa L. Aikens |
| **Year** | 2024 |
| **Journal** | Journal of Statistics and Data Science Education |
| **DOI** | https://doi.org/10.1080/26939169.2024.2365892 |
| **Your Name** | Emma Gius |
| **Date Started** | 1/12/2026 |

### 1.2 Quick Assessment

**What is this paper about?** (1-2 sentences)
This paper's goal is to explore the motivations of life science students towards statistics using the task-value facet model by Gaspard et al. (2015) in undergraduate statistics.

**Is data available?** ☑ Yes ☐ Partial ☐ No

**Is code available?** ☑ Yes ☐ Partial ☐ No

**Are statistical methods clearly stated?** ☑ Yes ☐ Somewhat ☐ No

---

## Part 2: GO/NO-GO Decision

### Decision Tree
```
1. Is ANY data available?
   └─ NO → STOP (cannot reproduce without data)
   └─ YES → Continue to #2

2. Is code available OR are methods clearly described?
   └─ NO → STOP (too difficult to reproduce)
   └─ YES → Continue to #3

3. Do you have the skills/time to reproduce this?
   └─ NO → STOP (consider a different paper)
   └─ YES → PROCEED WITH REPRODUCTION
```

### Your Decision

**Will you proceed?** ☑ Yes ☐ No

**Reproduction type:**
- ☑ Full reproduction (data + code available)
- ☐ Computational reproduction (data available, writing own code)
- ☐ Partial reproduction (some data/code missing)

**Why this decision?**

All the data is available and all the code is available, so there shouldn't be anything we lack in order to reproduce the paper in full.

---

## Part 3: Understanding the Paper

### 3.1 Abstract & Research Question

**Abstract summary (3-5 sentences):**

The study explored life science students' motivational attitudes towrds statistics, and their relationship to performance, using expectancy-value theory as a guiding framework. Using 360 undergratuate life science students enrolled in biostatistics courses across two institutions, the study assessed the fit of a task-value facets model for statistics and examineded which tack-value facets relate to performance on a statistics assessment. They found that students' perception of the emptional cost of statistics and the importance of achievement in statistics related to their statistics performance.

**Main research question(s):**
 
1. To assess whether the task-value facet model was appropriate for undergraduate life students and 
2. determine the relationship between students' task-values for statistics and their performance on a statistics assessment.

**Key findings:**

The study found that undergraduate life-science students' task-values towards statistics can be described using mutliple facets of task-values and that the lower their emotional cost was towards statistics, the better they performed on the assessment.

### 3.2 Statistical Methods Used

List the main statistical methods (you'll understand these better as you reproduce):

| Method | Brief Description | Used For |
|--------|-------------------|----------|
| Confirmatory Factor Analysis (CFA) | Tests how well measured variables predict unmeasrued or unmersuable events | Finding the factor loadings and the task-measure values of the task-values. |
| Multiple Linear Regression (MLR)   | Makes linear models with one continous variable and 2 or more independent variables to create a prediction model. | Used to make models that predict the outcome of the BioVEDA test. |
| AICc                               | Used to find the model that best balances between goodness of fit and model complexity. | Comparing the models made during the MLR stage to find which one best predicted the BioVEDA scores. |

---

## Part 4: Data Assessment

### 4.1 Data Inventory

**How many datasets does the paper use?** 1

For each dataset, fill out a table:

**Dataset 1:**

| Aspect | Details |
|--------|---------|
| **Dataset name** | StatsTaskValuesData |
| **Description** | Full Dataset that contains students responses to a survey that measures their task-values as well as the students scores of the BioVEDA exam. Each row represents a student and each column represents their answer/score on either a survey question or the exam question. |
| **Sample size (n)** | 360 |
| **Number of variables** | 59 (39 survey questions, 20 BioVEDA exam questions) |
| **Available?** | ☑ Yes ☐ Partial ☐ No |
| **Source/Location** | Haravard Database linked in article |
| **DOI/Link** | https://doi.org/10.7910/DVN/3P9AYO |
| **Format** | Excel |

---

### 4.2 Data Wrangling & Preprocessing

**What did the authors do to prepare the data?**

For each dataset, document the authors' data cleaning steps:

**Dataset 1 - Preprocessing:**

| Step | Author's Description | Details/Notes |
|------|---------------------|---------------|
| 1. Filter observations from Survey | Removed 5 students who were not Life Science majors, 3 students who choose not to divulge their majors, and 1 student who put the same survey response for every question | Done prior to assmebling the dataset that is avaliable to us |
| 2. Filter variables from BioVEDA | Removed Q5, Q7, Q14, and Q18 from the results | Based on Hicks et. al (2020) |
| 3. Further filtered variables from BioVEDA | Removed Q3 and Q16 | Students in the first semester only answered 14 out of the earlier 16, so to include a larger sample size of students, reduced the exam results to those 14 questions. |
| 4. Filtered observations from BioVEDA results | For MLR, only used students who completed all 14 BioVEDA questions | n = 263 for this analysis |

**Your data preparation:**

| Step | What You Did | Matches Paper? | Notes |
|------|--------------|----------------|-------|
| 1.   | Added a radomizer seed.  | ☑ Yes ☐ No ☐ Unclear | There was no randomizer seed in the code. |
| 2.   | Changed the code a bit so the data is reads from an .xlsx file instead of a .csv file. | ☑ Yes ☐ No ☐ Unclear | The data file provided was .xlsx not .csv. |
| 3.   | Further filtered variables from BioVEDA | ☑ Yes ☐ No ☐ Unclear | Already done in code. |
| 4.   | Filtered observations from BioVEDA results. | ☑ Yes ☐ No ☐ Unclear | Already done in code. |

**Final sample size:**

**Dataset 1: Survey Results**

- Paper reports: n = 360
- You obtained: n = 360
- Match? ☑ Yes ☐ No

**Dataset 1: BioVEDA Results**

- Paper reports: n = 263
- You obtained: n = 263
- Match? ☑ Yes ☐ No

---

## Part 5: Code Assessment

### 5.1 Code Availability

**Is code available?** ☑ Fully ☐ Partially ☐ Not at all

**If yes, where?** Harvard Database linked in the paper, `BioStatsAtts.R`, https://doi.org/10.7910/DVN/3P9AYO

**Programming language(s):** ☑ R ☐ Python ☐ Other: ___

---

### 5.2 Software Environment

**R/Python Version Information:**

| Software | Author's Version | Your Version |
| -------- | ---------------- | ------------ |
| R/Python | R v. 4.1.2 | R v. 4.5.2 |
| IDE      | Not Specified | Positron 2025.09.0 |

**Required Packages/Libraries:**

| Package | Author's Version | Your Version | Available? | Installation Issues? |
|---------|------------------|--------------|------------|---------------------|
| Lavaan | Not Specified | 0.6.21 | ☑ Yes ☐ No | N/A |
| car | Not Specified | 3.1.5 | ☑ Yes ☐ No | N/A |
| MuMIn | Not Specified | 1.48.11 | ☑ Yes ☐ No | N/A |
| semTools | Not Specified | 0.5.7 | ☑ Yes ☐ No | N/A |
| Hmisc | Not Specified | 5.2.5 | ☑ Yes ☐ No | N/A |
| mvnormtest | Not Specified | 0.1.9.3 | ☑ Yes ☐ No | N/A |
| performance | Not Specified | 0.16.0 | ☑ Yes ☐ No | N/A |
| ggeffects | Not Specified | 2.3.2 | ☑ Yes ☐ No | N/A |
| ggplot2 | Not Specified | 4.0.2 | ☑ Yes ☐ No | N/A |

---

### 5.3 Code Functionality Check

**Fill this out as you run the code:**

**Notes:** Used the code provided, it all worked

| Code Section | Purpose                      | Runs Successfully? | Errors Encountered | How You Fixed It |
|--------------|------------------------------|------------|---------------|------------------|
| Data loading | Import Excel dataset using provided R script | ☑ Yes ☐ No ☐ Partial | None | N/A |
| Data Cleaning and Descriptive Stats | Examine desriptive statistics (mean and sd) and test for normality without getting any errors | ☑ Yes ☐ No ☐ Partial | None | N/A | 
| CFA and Reliability testing (Omega) | Find the factor loadings, fit measure values, and factor correlations and reliabilties of all the task-values and their combination. | ☑ Yes ☐ No ☐ Partial | None | N/A |
| Data Cleaning for MLR | Removing a few questions/columns and making sure data has no missing values for modeling. | ☑ Yes ☐ No ☐ Partial | None | N/A |
| MLR | Run Multiple Linear Regresison Model. | ☑ Yes ☐ No ☐ Partial | None | N/A |
| Model comparison and AICc | Find which variables predict the BioVEDA the best, and find the model with the best balance of goodness-of-fit and model complexity. | ☑ Yes ☐ No ☐ Partial | None | N/A |

---

### 5.4 Random Seeds & Reproducibility

**Does the paper specify random seeds?** ☐ Yes (seed = ___) ☑ No

A random seed for this paper is not required as it is a deterministic analysis with no random elements. 

**Your approach:**
- If paper specifies seed: Use it
- If not: Document your seed = 220

**Seed sensitivity check:**

| Seed Value | Results | Notes |
|------------|---------|-------|
| 220        | Approximatly the same as the paper | There were small differences from the origional values. |
| 10         | Approximatly the same as the paper | N/A |  
| 167        | pproximatly the same as the paper  | N/A |  

**Note:** This is a deterministic analysis, seeds will not affect any of the results. 

**Are results stable across seeds?** ☑ Yes ☐ No ☐ Somewhat

---

## Part 6: Figure & Table Reproduction

### 6.1 Figures/Tables Inventory

List all figures and tables you're attempting to reproduce:

| Figure/Table | Description | Code Available? | Attempted? | Reproducible? | Results Match? | Notes |
|--------|-------------------|-----------------------------------------|----|-----------|----------------------------|-----------|
| Table 2 | Survey items and their mean student responses | ☑ Yes ☐ No ☐ Partial | ☑ Yes ☐ No | ☑ Yes ☐ No | ☐ Yes ☑ Mostly ☐ No | Factor Loadings: Combined Analysis differs for almost every factor. |
| Table 3 | Measure values for task-value models | ☑ Yes ☐ No ☐ Partial | ☑ Yes ☐ No | ☑ Yes ☐ No | ☑ Yes ☐ Mostly ☐ No | Matches exactly (within rounding) |
| Table 4 | Factor correlations and reliabilities in the 10-factor model representing task-value facets | ☑ Yes ☐ No ☐ Partial | ☑ Yes ☐ No | ☑ Yes ☐ No | ☑ Yes ☐ Mostly ☐ No | Matches exactly (within rounding) |
| Table 5 | Unstandardized regression coefficients, standard errors, and p-values | ☑ Yes ☐ No ☐ Partial | ☑ Yes ☐ No | ☑ Yes ☐ No | ☑ Yes ☐ Mostly ☐ No | Matches exactly (within rounding) |
| Table 6 | Best models predicting BioVEDA scores from model selection and their AICcs | ☑ Yes ☐ No ☐ Partial | ☑ Yes ☐ No | ☑ Yes ☐ No | ☑ Yes ☐ Mostly ☐ No | Matches exactly (within rounding) |

---

### 6.2 Detailed Results Comparison

Because of the sheer number of values across this paper, I found the mean of each metric across all the rows. 

**[Table 2]:** Items, their means (± standard deviation), and their standardized factor loadings.

| Metric/Value                        | Paper (Mean)  | Your Result (Mean) | Difference | Match?               |
|-------------------------------------|---------------|--------------------|------------|----------------------|
| Item Means                          | 4.320         | 4.319              | 0.001      | ☐ Yes ☑ Close ☐ No |
| SD                                  | 1.436         | 1.436              | 0          | ☑ Yes ☐ Close ☐ No |
| Factor Loading: Individual Analysis | 0.819         | 0.818              | 0.001      | ☐ Yes ☑ Close ☐ No |
| Factor Loading: Combined Analysis   | 0.821         | 0.820              | 0.001      | ☐ Yes ☑ Close ☐ No |    


**Possible reasons for differences:**

The differences between values are never more than 0.001. Which leads me to believe that the differences are likly due to randomness and the variability of the models themselves.


**[Table 3]:**  Fit measure values for task-value models.

| Metric/Value | Paper (Mean) | Your Result (Mean) | Difference | Match?               |
|--------------|--------------|--------------------|------------|----------------------|
| χ²           | 626.477      | 626.477            | 0          | ☑ Yes ☐ Close ☐ No |
| DF           | 142.778      | 142.778            | 0          | ☑ Yes ☐ Close ☐ No |
| p-value      | 0.056        | 0.056              | 0          | ☑ Yes ☐ Close ☐ No |
| CFI          | 0.863        | 0.865              |-0.002      | ☐ Yes ☑ Close ☐ No |    
| TLI          | 0.831        | 0.862              |-0.001      | ☐ Yes ☑ Close ☐ No |    
| RMSEA        | 0.121        | 0.120              | 0.001      | ☐ Yes ☑ Close ☐ No |    
| SRMR         | 0.073        | 0.073              |-0.0        | ☐ Yes ☑ Close ☐ No |   


**Possible reasons for differences:**
   
Similarly to table 2, table 3 uses the same models to find the fit measure values. Since the models themselves likely have some randomness involved, there are small differences that are usually less than (absolute) 0.001. I don't know why but for one of my p-values, I kept getting over 0.001 (rounded to 0.002), however I couldn't figure out why. I'm guessing there is a human error on my side or they forgot to round a value properly.

**[Table 4]:**  Factor correlations and reliabilities in the 10-factor model representing task-value facets.

| Mean Absolute Value   | Paper (Mean) | Your Result (Mean) | Difference | Match?               |
|-----------------------|--------------|--------------------|------------|----------------------|
| Interest correlations | 0.3107273    | 0.3105455          | 0.0001818182 | ☐ Yes ☑ Close ☐ No |


**Possible reasons for differences:**
   
I chose mean absolute value because I couldn't figure out how to label the results. That said, my results have small differences from the paper, but it's less than 0.001. So I believe this is again caused by the randomness of the model and rounding issues rather than human error.


**[Table 5]:**   Unstandardized regression coefficients, standard errors, and p-values.

| Metric/Value   | Paper (Mean) | Your Result (Mean) | Difference | Match?               |
|----------------|--------------|--------------------|------------|----------------------|
| Estimate       | -0.11        | -0.11              | 0          | ☑ Yes ☐ Close ☐ No |
| Standard Error | 0.24         | 0.24               | 0          | ☑ Yes ☐ Close ☐ No |
| p-value        | 0.44         | 0.44               | 0          | ☑ Yes ☐ Close ☐ No |
 

**Possible reasons for differences:**
   
All of the values match exactly.

**[Table 6]:** Best models predicting BioVEDA scores from model selection.

| Metric/Value   | Paper (Mean) | Your Result (Mean) | Difference | Match?               |
|----------------|--------------|--------------------|------------|----------------------|
| AICc           |1194.573      | 1194.572           | 0.001      | ☐ Yes ☑ Close ☐ No |

 

**Possible reasons for differences:**
   
Exactly one model (the third model from the top specifically) has less than a 0.01 difference between it and the paper. I attribute this to the randomness of models again, or a small rounding difference.

---

### 6.3 Sensitivity Checks

**Are figures sensitive to different perturbations?**

**Note:** No need to have sensitivity checks for this paper. This is a deterministic analysis and assumes no randomness, so seeds will not have an affect on the results. Because of the nature of the code, changing the parameters is not appropriate. Results are always stable and consistent. 

---

## Part 7: Issues Log

**FILL THIS OUT AS YOU GO - Don't wait until the end!**

**Issue Types:**

- **Data:** missing, inaccessible, format issues, size mismatch
- **Code:** errors, missing functions, package issues, version conflicts
- **Methods:** ambiguous description, parameters not specified, unclear preprocessing

**Impact Scale:**

- **High:** Prevents reproduction or changes main conclusions
- **Medium:** Affects numerical results but not overall findings
- **Low:** Minor cosmetic differences

### 7.1 Problems Encountered

| # | Type | Description | Impact | How You Handled It | Status |
|---|------|-------------|--------|-------------------|--------|
| 1 | Code | I got an error saying "there is no package called 'see'" when running "check_model(fit.glm.1)". | Low | I downloaded the 'see' library, but it wouldn't appear properly in "PLOTS". Fortunately, it's just another way of plotting. It doesn't really effect anything. | Resolved |


**Impact Summary**:
This had negligble impact on the reproduction since the plot was never used in the paper itself, and has no effect on the results of the paper.


---

### 7.2 Key Assumptions You Made

List every assumption you made during reproduction:

Because the code and the complete dataset was provided in full, I did not have to make any key assumptions. 

---

## Part 8: Final Reproducibility Assessment

### 8.1 Overall Reproducibility Score

**Your Score: 9/10**

**Scoring Guide:**

- **9-10:** Near-exact replication - all main results match within rounding
- **7-8:** Close match - minor numerical differences, same conclusions
- **5-6:** Partial match - general trends match, some specifics differ
- **3-4:** Poor match - substantial differences in results
- **0-2:** Non-reproducible - major barriers, couldn't replicate findings

**Justification for your score:**

I managed to reproduce all of the tables, but a few of the results were a little off. I sincely believe it was rounding differences between my models and the paper itself. The paper rounded their results, so differences are expected.

**What matched:**

- ☑ Main statistical results (coefficients, p-values, etc.)
- ☑ Tables show same conclusions
- ☑ Sample sizes match
- ☑ Effect sizes are similar

**What didn't match:**

- ☑ Some numerical values differ
- ☐ Confidence intervals differ
- ☐ Some figures differ
- ☐ Sample sizes differ
- ☐ Other: ___

---

### 8.2 Reproducibility Summary

**What made reproduction easier:**

The code was clearly labeled so I knew where to find which models, and where the MLR actually took place in the code. They also did a lot of the work, from cleaning the data to having the models already made. I do feel the need to appreciate that this paper already had all the code as well, even though it's technically a requriement to reproduce it in the first place.

**What made reproduction harder:**

Nothing big. The professor helped me load the code properly since they have a .xlsx file, but their code expected a .csv file. The learning curve was mostly finding which numbers in their table correlated to which models in their code. I think that was the hardest part. The second hardest was figuring out how to properly compare the paper results to my tables, and how to do that in the best way possible. There weren't exactly clear instudtcions and there a lot of item to compare, and I did not want to compare them one by one.

**What could the authors have done better:**

Include the sessionInfo() output and specify the versions of the packages that was used.

**Advice for future reproducers of this paper:**

Be weary of the Factor Loadings: Combined Analysis column in Table 2. Run the code part by part so you can keep track of the results.

---

## Part 9: Computational Environment

**Document your complete environment:**
```r
# For R users:
sessionInfo()

R version 4.5.1 (2025-06-13 ucrt)
Platform: x86_64-w64-mingw32/x64
Running under: Windows 11 x64 (build 26200)

Matrix products: default
  LAPACK version 3.12.1

locale:
[1] LC_COLLATE=English_United States.utf8 
[2] LC_CTYPE=English_United States.utf8   
[3] LC_MONETARY=English_United States.utf8
[4] LC_NUMERIC=C                          
[5] LC_TIME=English_United States.utf8    

time zone: America/Los_Angeles
tzcode source: internal

attached base packages:
[1] stats     graphics 
[3] grDevices utils    
[5] datasets  methods  
[7] base      grid

other attached packages:
  [1] see_0.13.0         
  [2] MuMIn_1.48.11      
  [3] ggplot2_4.0.2      
  [4] ggeffects_2.3.2    
  [5] car_3.1-5          
  [6] carData_3.0-5     
  [7] performance_0.16.0 
  [8] semTools_0.5-7     
  [9] lavaan_0.6-21      
  [10] mvnormtest_0.1-9-3 
  [11] Hmisc_5.2-5      

loaded via a namespace (and not attached):
[1] gtable_0.3.6       bayestestR_0.17.0  xfun_0.53          htmlwidgets_1.6.4  ggrepel_0.9.6      insight_1.4.6     
[7] lattice_0.22-7     quadprog_1.5-8     vctrs_0.6.5        tools_4.5.1        generics_0.1.4     datawizard_1.3.0  
[13] parallel_4.5.1     stats4_4.5.1       tibble_3.3.0       cluster_2.1.8.1    pkgconfig_2.0.3    Matrix_1.7-3      
[19] data.table_1.17.8  checkmate_2.3.3    RColorBrewer_1.1-3 S7_0.2.0           readxl_1.4.5       lifecycle_1.0.4   
[25] compiler_4.5.1     farver_2.1.2       stringr_1.5.2      textshaping_1.0.3  mnormt_2.1.2       htmltools_0.5.8.1 
[31] htmlTable_2.4.3    Formula_1.2-5      pillar_1.11.1      MASS_7.3-65        rpart_4.1.24       abind_1.4-8       
[37] nlme_3.1-168       tidyselect_1.2.1   digest_0.6.37      stringi_1.8.7      dplyr_1.1.4        splines_4.5.1     
[43] labeling_0.4.3     fastmap_1.2.0      colorspace_2.1-2   cli_3.6.5          magrittr_2.0.4     patchwork_1.3.2   
[49] base64enc_0.1-3    pbivnorm_0.6.0     foreign_0.8-90     withr_3.0.2        scales_1.4.0       backports_1.5.0   
[55] rmarkdown_2.30     nnet_7.3-20        gridExtra_2.3      cellranger_1.1.0   ragg_1.5.0         evaluate_1.0.5    
[61] knitr_1.50         parameters_0.28.3  mgcv_1.9-3         rlang_1.1.6        Rcpp_1.1.0         glue_1.8.0        
[67] rstudioapi_0.17.1  R6_2.6.1           systemfonts_1.3.1 

```

---

## Part 10: Your Reproduction Materials

**Where are your materials located?**

- Repository link: N/A
- Branch/folder: N/A
- README included? ☐ Yes ☑ No

**What you're sharing:**

- ☐ Your code (well-commented)
- ☑ This completed template
- ☐ Output figures/tables
- ☐ Data (if shareable)
- ☑ Notes on issues encountered

---

## Template Information

**Version:** 2.0  
**Date:** December 2025  
**Your Name:** Sharry Eydel  
**Time Spent on Reproduction:** Approximately 10 hours  
**Completion Date:** 3/9/2026

---

**Final Reminder:** 

Reproducibility is challenging! The goal isn't perfection - it's understanding. Document thoroughly, be honest about limitations, and remember that your efforts help advance open science.

If results don't match exactly, that's valuable information. Understanding *why* they differ is often more important than getting a perfect match.