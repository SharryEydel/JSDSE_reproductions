# The Landscape of College-level Data Visualization Courses, and the Benefits of Incorporating Statistical Thinking

This repository contains the data and code used to replicate all results and figures in the manuscript "The Landscape of College-level Data Visualization Courses, and the Benefits of Incorporating Statistical Thinking". There are two main parts of the paper: Section 2 discusses results from a survey of 270 data visualization courses at top colleges and universities in the United States, and Section 3 presents examples illustrating how to incorporate statistical thinking into data visualization courses.  

The data folder is organized as follows:

+ The survey data folder corresponds to data used in Section 2. This includes the raw data from the survey of data visualization courses (`DataVisualizationClassSurvey.xlsx`), as well as the processed data used to make figures in the paper (`survey_results.csv`). As described below, the processed data was created using the code `s0_prep_survey_sheets.R`. 

+ The datasets for examples folder corresponds to data used in Section 3. This includes the American Community Survey dataset used to make Figure 7 (`acs2015.csv`), as well as the Spotify dataset used to make Table 4 and Figures 6 and 9 (`spotify.csv`). As described in the paper, both datasets are originally from Kaggle.

The raw survey data `DataVisualizationClassSurvey.xlsx` is an Excel file with multiple tabs. One tab contains information about the 104 universities we surveyed, and another tab contains information about the 50 liberal arts colleges we surveyed. The Excel file also contains colored highlights, and another tab communicates what the highlights denote (in short, they denote whether a course catalog was publicly available for a particular school). Meanwhile, the processed survey data `survey_results.csv` contains 154 observations (rows), denoting these 104 universities and 50 colleges. Thus, observations are at the school level, rather than the course level; multiple courses from a single school are organized by columns. As discussed below, the `s1_create_survey_figures.R` file in the code folder demonstrates how to identify the 270 data visualization courses captured by `survey_results.csv`.

More details about the survey data (e.g., variable descriptions and example exercises instructors can consider using this data) can be found in Carnegie Mellon's Statistics and Data Science Repository [here][1].

The code folder is organized as follows:

+ `s0_prep_survey_sheets.R` cleans the collected data about data visualization courses found in `DataVisualizationClassSurvey.xlsx` to obtain `survey_results.csv`.

+ `s1_create_survey_figures.R` uses the survey data `survey_results.csv` to generate summary statistics and Figures 1-4 from Section 2 of the paper (based on exploration in `sandbox.R`).

+ `barplotExample.R` replicates Figure 5 from Section 3 of the paper.

+ `densityExample.R` replicates Figure 6 from Section 3 of the paper using the `spotify.csv` dataset.

+ `mapsExample.R` replicates Figure 7 from Section 3 of the paper using the `acs2015.csv` dataset.

+ `linIntExample.R` replicates Figure 8 and Table 3 from Section 3 of the paper. This code uses election data that we are not able to publicly share; instead, the code describes the structure of the data and provides the code used to create the figure and table.

+ `pcaExample.R` replicates Figure 9 and Table 4 from Section 3 of the paper using the `spotify.csv` dataset.

All code is well-commented, such that others can replicate all of our results and figures step-by-step, as well as identify what lines of code recreate particular figures in the paper.

  [1]: https://cmustatistics.github.io/data-repository/social/data-viz-survey.html

