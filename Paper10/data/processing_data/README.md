This directory contains RMarkdown documents that move raw data to anonymized or processed data. Some files cannot be run as-is, either because the raw data cannot be made public or because they rely on directories on the author's computer. However, all files are made available for transparency about the processes. Files are listed in decreasing order of likelihood that another researcher might be interested in the code.

- The file `CountingFunctions.Rmd` explains how to generate the .R files found in `data/prelabs/`, and moves from that set of script files to the processed files `allfunctions.csv` and `csfunctions.csv`. 
- The file `CountingLines.Rmd` explains how to count the number of lines in a set of RMarkdown documents, and generates the `lablines.csv` file. 
- The file `YouTubeData.Rmd` moves from raw data downloaded from YouTube's Analytics (Advanced Mode) to the anonymized file `YouTube.csv`. It goes further and generates the processed files `youtube_videos.csv` and `youtube_weeks.csv`. 
- The file `RStudioCloudData.Rmd` moves from raw data downloaded from rstudio.cloud to anonymized files `tidy_rstudio.csv` and `formula_rstudio.csv`. It goes further and generates the processed file `rstudio_cloud.csv`.
- The file `SurveyData.Rmd` moves from raw data from the pre- and post-surveys done in Qualtrics surveys to the anonymized file `prepost.csv`.






