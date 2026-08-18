# PURPOSE: Begin exploring survey results with just basic info like how many
#          universities have a data viz class, the total number of courses that
#          we find, etc.

library(tidyverse)

# Load the survey results -------------------------------------------------

clean_survey_file <- read_csv("Paper2/Materials/data/survey data/survey_results.csv")

table(clean_survey_file$type)
# liberal_arts   university 
#           50          104 

length(unique(clean_survey_file$university))
# [1] 154


# Only consider the courses with accessible course catalogs ---------------

main_survey_results <- clean_survey_file |>
  filter(course_catalog_accesible)

# How many were we able to access?
table(main_survey_results$type)
# liberal_arts   university 
#           46           89 

# How many schools have courses? ------------------------------------------

table(main_survey_results$did_it_include_any_class)
# FALSE  TRUE 
#    41    94 

table("Type" = main_survey_results$type,
      "Include a class?" = main_survey_results$did_it_include_any_class)
#           Include a class?
# Type           FALSE TRUE
#   liberal_arts    30   16
#   university      11   78

# Huh, interesting - majority of the liberal arts do NOT feature a data viz class

# Create class level dataset ----------------------------------------------

# Most annoying part of working with this sheet, need to pivot to make it longer
# so that each row is a class

course_level_info <- main_survey_results |>
  dplyr::select(university, type, course_1_name:course_15_software) |>
  dplyr::select(-contains("notes")) |>
  pivot_longer(cols = course_1_name:course_15_software,
               names_to = c("class", ".value"),
               names_pattern = "course_(\\d+)_(.+)")
nrow(course_level_info) == (nrow(main_survey_results) * 15)
# [1] TRUE

# Successfully pivoted using the above code

# histogram with 0s for schools
course_count_hist <- course_level_info |>
  group_by(university) |>
  summarize(n_courses = length(which(!is.na(name)))) |>
  ggplot(aes(x = n_courses)) +
  geom_histogram(binwidth = 1, center = 0, closed = "left",
                 color = "white", fill = "darkblue") +
  theme_light() +
  labs(x = "Number of identified data visualization classes taught within a school",
       y = "Number of schools")
cowplot::save_plot("Paper2/Materials/figs/hist_n_courses.pdf",
                   course_count_hist, ncol = 1, nrow = 1)

# Remove missing rows based on name:
course_level_info <- course_level_info |>
  filter(!is.na(name))
# Results in 270 courses in total (makes sense)

# How many schools with classes?
length(unique(course_level_info$university))
# [1] 94
94 / 154
# [1] 0.6103896

# Basic exploration of class level data -----------------------------------

course_level_info |>
  group_by(university) |>
  count() |>
  arrange(desc(n))
#     university                          n
#     <chr>                           <int>
#   1 Georgetown University              15
#   2 New York University                14
#   3 Northeastern University            13
#   4 Carnegie Mellon University          8
#   5 University of Notre Dame            8
#   6 Northwestern University             7
#   7 Duke University                     6
#   8 Purdue University                   6
#   9 Stevens Institute of Technology     6
#  10 University of Minnesota             6
# Okay - should mention these for the paper, which stand out in terms of the 
# sheer number that are there...
  
# Course level?
table(course_level_info$level)  
# Both          Grad      Graduate      Undegrad     Undergrad Undergraduate 
# 63            99             2             1           103             2 
# Ugh - neeed to combine these...

course_level_info <- course_level_info |>
  mutate(level = ifelse(str_detect(tolower(level), "und"),
                        "undergrad",
                        ifelse(str_detect(tolower(level),
                                          "both"),
                               "both", "grad")))
table(course_level_info$level)
# both      grad undergrad 
# 63       101       106
# That's surprisingly balanced...

# Can imagine making some word clouds of the course names and topics...

# What about the department?
length(unique(course_level_info$dept))
# [1] 163

# Okay that's way too many to initially look at... what are the types of depts
# that contain "stat" or "data" in them?

course_level_info <- course_level_info |>
  mutate(is_stats = as.numeric(str_detect(tolower(dept), "stat")))
course_level_info |>
  filter(is_stats == 1) |>
  pull(dept) |>
  unique()
# [1] "Statistical Science, Information Science + Studies"              
# [2] "Statistical Science"                                             
# [3] "Statistics and Data Science"                                     
# [4] "Mathematics and Statistics, Computers and Information Management"
# [5] "Statistics"                                                      
# [6] "Applied Statistics, Social Science, and Humanities"              
# [7] "Statistics and Operations Research"                              
# [8] "Information Technology, Statistics" 

# Repeat for "data"
course_level_info <- course_level_info |>
  mutate(is_ds = as.numeric(str_detect(tolower(dept), "data")))
course_level_info |>
  filter(is_ds == 1) |>
  pull(dept) |>
  unique()
#  [1] "Data Science Institute"                        "Data Science"                                 
#  [3] "Statistics and Data Science"                   "Data Analytics"                               
#  [5] "Data Sciece"                                   "Data Science and Analytics"                   
#  [7] "Data Science (Public Policy)"                  "Data Analytics for Science"                   
#  [9] "Applied Data Analytics and Visualization"      "Environmental Data Science"                   
# [11] "Data Science and Engineering"                  "Applied Data Science"                         
# [13] "Computer Science, Data Science"                "Journalism and Media Management, Data Science"
# [15] "Data Analytics & Visualization"                "Data Science, Informatics"                    
# [17] "Data Science, Information Systems"             "Data for Political Research"      

# Spot a mispelling there...

# Okay - so how many data viz classes are from stats depts?
table(course_level_info$is_stats)
#   0   1 
# 252  18
table(course_level_info$is_stats) / nrow(course_level_info)
#          0          1 
# 0.93333333 0.06666667 

# For data science?
table(course_level_info$is_ds)
#   0   1 
# 236  34 
table(course_level_info$is_ds) / nrow(course_level_info)
#   0   1 
# 0.8740741 0.1259259  

# Split by level:
course_level_info |>
  group_by(level, is_stats) |>
  summarize(n_classes = n(),
            .groups = "drop") |>
  group_by(level) |>
  mutate(total_classes = sum(n_classes)) |>
  ungroup() |>
  mutate(frac_classes = n_classes / total_classes)
#     level     is_stats n_classes total_classes frac_classes
#     <chr>        <dbl>     <int>         <int>        <dbl>
#   1 both             0        61            63       0.968 
#   2 both             1         2            63       0.0317
#   3 grad             0        96           101       0.950 
#   4 grad             1         5           101       0.0495
#   5 undergrad        0        95           106       0.896 
#   6 undergrad        1        11           106       0.104 

# Okay nice - pretty consistent here...

course_level_info |>
  group_by(level, is_stats) |>
  summarize(n_classes = n(),
            .groups = "drop") |>
  mutate(level = fct_relevel(level, "undergrad", "grad", "both"),
         level = fct_recode(level, Both = "both", 
                            `Undergraduate-only` = "undergrad",
                            `Graduate-only` = "grad")) |>
  ggplot(aes(x = level, y = n_classes, fill = as.factor(is_stats))) +
  geom_bar(stat = "identity", position = "stack") +
  ggthemes::scale_fill_colorblind(labels = c("No", "Yes")) +
  labs(x = "Student-level", y = "Number of classes",
       fill = "Taught by Statistics department?") +
  theme_light() +
  theme(legend.position = "bottom")

course_level_info |>
  group_by(level, is_ds) |>
  summarize(n_classes = n(),
            .groups = "drop") |>
  group_by(level) |>
  mutate(total_classes = sum(n_classes)) |>
  ungroup() |>
  mutate(frac_classes = n_classes / total_classes)
# # A tibble: 6 × 5
#     level     is_ds n_classes total_classes frac_classes
#     <chr>     <dbl>     <int>         <int>        <dbl>
# 1 both          0        56            63        0.889
# 2 both          1         7            63        0.111
# 3 grad          0        87           101        0.861
# 4 grad          1        14           101        0.139
# 5 undergrad     0        93           106        0.877
# 6 undergrad     1        13           106        0.123

course_level_info |>
  group_by(level, is_ds) |>
  summarize(n_classes = n(),
            .groups = "drop") |>
  mutate(level = fct_relevel(level, "undergrad", "grad", "both"),
         level = fct_recode(level, Both = "both", 
                            `Undergraduate-only` = "undergrad",
                            `Graduate-only` = "grad")) |>
  ggplot(aes(x = level, y = n_classes, fill = as.factor(is_ds))) +
  geom_bar(stat = "identity", position = "stack") +
  ggthemes::scale_fill_colorblind(labels = c("No", "Yes")) +
  labs(x = "Student-level", y = "Number of classes",
       fill = "Taught by Data Science department?") +
  theme_light() +
  theme(legend.position = "bottom")

# Yup... majority do not come from stats or data science depts, and that's 
# probably being generous given the stat/data tag

# Make a combined version:
course_level_info |>
  mutate(is_stat_ds = pmax(is_stats, is_ds)) |>
  group_by(is_stat_ds) |> 
  summarize(n_classes = n(), .groups = "drop") |>
  mutate(total_classes = sum(n_classes)) |>
  ungroup() |>
  mutate(frac_classes = n_classes / total_classes)
# # A tibble: 2 × 4
#             is_stat_ds n_classes total_classes frac_classes
#                 1 <dbl>     <int>         <int>        <dbl>
#            1          0       220           270        0.815
#            2          1        50           270        0.185

course_level_info |>
  mutate(is_stat_ds = pmax(is_stats, is_ds)) |>
  group_by(level, is_stat_ds) |>  
  summarize(n_classes = n(),
            .groups = "drop") |>
  group_by(level) |>
  mutate(total_classes = sum(n_classes)) |>
  ungroup() |>
  mutate(frac_classes = n_classes / total_classes)
# # A tibble: 6 × 5
#     level     is_stat_ds n_classes total_classes frac_classes
#     <chr>          <dbl>     <int>         <int>        <dbl>
# 1 both               0        55            63        0.873
# 2 both               1         8            63        0.127
# 3 grad               0        82           101        0.812
# 4 grad               1        19           101        0.188
# 5 undergrad          0        83           106        0.783
# 6 undergrad          1        23           106        0.217

dept_level_bars <- course_level_info |>
  mutate(is_stat_ds = pmax(is_stats, is_ds)) |>
  group_by(level, is_stat_ds) |>
  summarize(n_classes = n(),
            .groups = "drop") |>
  mutate(level = fct_relevel(level, "undergrad", "grad", "both"),
         level = fct_recode(level, Both = "both", 
                            `Undergraduate-only` = "undergrad",
                            `Graduate-only` = "grad")) |>
  ggplot(aes(x = level, y = n_classes, fill = as.factor(is_stat_ds))) +
  geom_bar(stat = "identity", position = "stack") +
  ggthemes::scale_fill_colorblind(labels = c("No", "Yes")) +
  labs(x = "Student-level", y = "Number of classes",
       fill = "Taught by statistics and/or data science department?") +
  theme_light() +
  theme(legend.position = "bottom")
dept_level_bars
cowplot::save_plot("Paper2/Materials/figs/dept_level_bars.pdf",
                   dept_level_bars, ncol = 1, nrow = 1)


# Frequency of topics we discuss ------------------------------------------

# How many classes had topics?
course_level_info |>
  filter(topic_list != "None", !is.na(topic_list)) |>
  nrow()
# [1] 142 - okay so a good number

# How many classes didn't have available topics?
sum(is.na(course_level_info$topic_list))
# [1] 14
mean(is.na(course_level_info$topic_list))
# [1] 0.05185185

# Figure out the topics to search for:
unique(str_split(paste0(course_level_info$topic_list, collapse = ", "), ", ")[[1]])
# [1] "None"                                    "Interactive Graphics"                   
# [3] "Networks"                                "Spatial Data"                           
# [5] "NA"                                      "High Dimensional"                       
# [7] "Statistical Modeling"                    "Hypothesis Testing"                     
# [9] "Time Series"                             "Text Data"                              
# [11] "Statistical Modeling (Regression)"       "Clustering"                             
# [13] "Text Analysis"                           "Hypothesis Testing/Confidence Intervals"
# [15] " Interactive Graphics"                   "Spatial data"                           
# [17] "Confidence Intervals"      

# First look up all topics:
all_topics <- c("interactive graphics", "networks", "spatial data",
                "high dimensional", "time series", "text data", "clustering",
                "text analysis",
                "hypothesis testing", "confidence intervals",
                "statistical modeling",
                "none")

topic_counts <- map_dfr(all_topics,
                        function(topic) {
                          topic_count <- course_level_info |>
                            mutate(topic_list = tolower(topic_list)) |>
                            filter(str_detect(topic_list, str_c(topic))) |>
                            nrow()
                          tibble(class_topic = topic,
                                 n_classes = topic_count)
                        }) |>
  # alter text analysis to be text data:
  mutate(class_topic = ifelse(class_topic == "text analysis",
                              "text data", class_topic)) |>
  group_by(class_topic) |>
  summarize(n_classes = sum(n_classes),
            .groups = "drop")

# Make a bar chart of these topic counts:
topic_count_bars <- topic_counts |>
  mutate(class_topic = fct_reorder(class_topic, n_classes)) |>
  ggplot(aes(x = class_topic, y = n_classes)) +
  geom_bar(stat = "identity",
           fill = "darkblue", color = "white") +
  coord_flip() +
  theme_light() +
  labs(x = "Topic",
       y = "Number of courses covering topic")
topic_count_bars
cowplot::save_plot("Paper2/Materials/figs/topic_count_bars.pdf",
                   topic_count_bars, ncol = 1, nrow = 1)

# Number and proportion of courses that cover each topic
topic_counts
#    class_topic          n_classes
#    <chr>                    <int>
#  1 clustering                  10
#  2 confidence intervals         2
#  3 high dimensional            21
#  4 hypothesis testing           4
#  5 interactive graphics       105
#  6 networks                    32
#  7 none                       114
#  8 spatial data                51
#  9 statistical modeling         7
# 10 text data                   18
# 11 time series                 26

# Understanding *how many topics* each course teaches:
#create an indicator for each topic
topicChecks = course_level_info %>% reframe(
  clustering = as.numeric(grepl("clustering", tolower(topic_list))),
  CIs = as.numeric(grepl("confidence intervals", tolower(topic_list))),
  highDim = as.numeric(grepl("high dimensional", tolower(topic_list))),
  testing = as.numeric(grepl("hypothesis testing", tolower(topic_list))),
  interactive = as.numeric(grepl("interactive graphics", tolower(topic_list))),
  networks = as.numeric(grepl("networks", tolower(topic_list))),
  spatial = as.numeric(grepl("spatial data", tolower(topic_list))),
  modeling = as.numeric(grepl("statistical modeling", tolower(topic_list))),
  text = as.numeric(grepl("text", tolower(topic_list))),
  time = as.numeric(grepl("time series", tolower(topic_list)))
  )
#count total number of topics
course_level_info$numTopics = rowSums(topicChecks)
#however, if topic_list is NA, change numTopics to NA
course_level_info$numTopics = ifelse(
  is.na(course_level_info$topic_list), NA,
  course_level_info$numTopics)

# histogram of number of topics
topic_count_hist <- course_level_info |>
  ggplot(aes(x = numTopics)) +
  geom_histogram(binwidth = 1, center = 0, closed = "left",
                 color = "white", fill = "darkblue") +
  theme_light() +
  labs(x = "Number of topics taught",
       y = "Number of courses") +
  scale_x_continuous(breaks = 0:10)
topic_count_hist

#Proportion of courses that teach each number of topics:
prop.table(table(course_level_info$numTopics))
#How many (and what proportion) teach at most 2 topics?
sum(course_level_info$numTopics <= 2, na.rm = TRUE)
mean(course_level_info$numTopics <= 2, na.rm = TRUE)

# More closely examining which courses
# did not cover any of the topics:
courses_noTopics = subset(course_level_info, topic_list == "None",
  select = c(name, dept))       # Sharry: Type on this line, was "ame" not "name"
print(courses_noTopics, n = 114)

# More closely examining which courses
# covered interactive graphics:
print(subset(course_level_info[which(topicChecks$interactive == 1),],
  select = c(name, dept)), n = 105)

# More closely examining which courses
# covered spatial data:
print(subset(course_level_info[which(topicChecks$spatial == 1),],
  select = c(name, dept)), n = 105)

# Set-up a vector of topics 
stat_topics <- c("hypothesis testing", "confidence intervals",
                 "statistical modeling")

# How many courses cover these topics?
courses_by_topics <- map(stat_topics,
                         function(topic) {
                           
                           # Just return the courses with this topic:
                           course_level_info |>
                             mutate(topic_list = tolower(topic_list)) |>
                             filter(str_detect(topic_list, str_c(topic)))
                           
                         })
names(courses_by_topics) <- stat_topics
sapply(courses_by_topics, function(x) x$university)
# $`hypothesis testing`
# [1] "Duke University"            "Columbia University"        "Carnegie Mellon University"
# [4] "Brigham Young University"  
# 
# $`confidence intervals`
# [1] "Carnegie Mellon University" "Colby College"             
# 
# $`statistical modeling`
# [1] "Duke University"            "Brown University"           "Georgetown University"     
# [4] "Georgetown University"      "Carnegie Mellon University" "University of Minnesota"   
# [7] "Colby College"        
# Okay - so no visualization needed here... thsi is really really limited then...
# Colby is Jerzy's class so that would explain the similarity there, and Duke 
# is not surprising at all

# Print out the depts:
lapply(courses_by_topics, function(x) dplyr::select(x, university, dept))
# $`hypothesis testing`
# # A tibble: 4 × 2
#     university                 dept                                              
#     <chr>                      <chr>                                             
#   1 Duke University            Statistical Science, Information Science + Studies
#   2 Columbia University        Computer Science                                  
#   3 Carnegie Mellon University Statistics and Data Science                       
#   4 Brigham Young University   Political Science                                 
# 
# $`confidence intervals`
# # A tibble: 2 × 2
#     university                 dept                       
#     <chr>                      <chr>                      
#   1 Carnegie Mellon University Statistics and Data Science
#   2 Colby College              Statistics                 
# 
# $`statistical modeling`
# # A tibble: 7 × 2
# university                 dept                                              
# <chr>                      <chr>                                             
#   1 Duke University            Statistical Science, Information Science + Studies
#   2 Brown University           Computer Science                                  
#   3 Georgetown University      Data Science and Analytics                        
#   4 Georgetown University      Learning, Design, and Technology                  
#   5 Carnegie Mellon University Statistics and Data Science                       
#   6 University of Minnesota    Information and Decision Science                  
#   7 Colby College              Statistics  

# huh - not what I expected, would've thought that this would be entirely stats


# Create word clouds of departments, class names, and topics --------------

# Start with departments
library(tidytext)
data(stop_words)

course_dept_text <- course_level_info |>
  dplyr::select(university, class, dept) |>
  unnest_tokens(word, dept) |>
  filter(!(word %in% stop_words$word)) |>
  group_by(word) |>
  summarize(freq = n(), .groups = "drop")

library(wordcloud)
wordcloud(words = course_dept_text$word,
          freq = course_dept_text$freq, 
          random.order = FALSE,
          max.words = 100, 
          colors = brewer.pal(8, "Dark2"))
# That makes sense.... and is a good one to potentially use

# Repeat for course names:
course_name_text <- course_level_info |>
  dplyr::select(university, class, name) |>
  unnest_tokens(word, name) |>
  filter(!(word %in% stop_words$word)) |>
  group_by(word) |>
  summarize(freq = n(), .groups = "drop")

wordcloud(words = course_name_text$word,
          freq = course_name_text$freq, 
          random.order = FALSE,
          max.words = 100, 
          colors = brewer.pal(8, "Dark2"))
# Well that's not interesting...

# And for topics:
course_topics_text <- course_level_info |>
  filter(topic_list != "None", # note - none is a stop word apparently..
         !is.na(topic_list)) |>
  dplyr::select(university, class, topic_list) |>
  unnest_tokens(word, topic_list) |>
  filter(!(word %in% stop_words$word)) |>
  group_by(word) |>
  summarize(freq = n(), .groups = "drop")

wordcloud(words = course_topics_text$word,
          freq = course_topics_text$freq, 
          random.order = FALSE,
          max.words = 100, 
          colors = brewer.pal(8, "Dark2"))
# Okay so interactive graphics is really popular...

