# PURPOSE: Explore survey results and create manuscript figures based on survey

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

# Create class level dataset ----------------------------------------------

course_level_info <- main_survey_results |>
  dplyr::select(university, type, course_1_name:course_15_software) |>
  dplyr::select(-contains("notes")) |>
  pivot_longer(cols = course_1_name:course_15_software,
               names_to = c("class", ".value"),
               names_pattern = "course_(\\d+)_(.+)")

# Create plot for number of courses within a school
# (This creates Figure 1 in the paper)
course_count_hist <- course_level_info |>
  group_by(university) |>
  summarize(n_courses = length(which(!is.na(name)))) |>
  ggplot(aes(x = n_courses)) +
  geom_histogram(binwidth = 1, center = 0, closed = "left",
                 color = "white", fill = "black") +
  theme_light() +
  labs(x = "Number of identified data visualization classes taught within a school",
      y = "Number of schools")
course_count_hist
cowplot::save_plot("Paper2/Materials/figs/hist_n_courses.pdf",
                   course_count_hist, ncol = 1, nrow = 1)

# Remove missing rows based on name:
course_level_info <- course_level_info |>
  filter(!is.na(name))

# How many schools with classes?
length(unique(course_level_info$university))
# [1] 94
94 / 154
# [1] 0.6103896

# How many courses have URLs available?
sum(!is.na(course_level_info$url))
# [1] 166
166/270
# [1] 0.6148148

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

# Course level?
table(course_level_info$level)  
# Both          Grad      Graduate      Undegrad     Undergrad Undergraduate 
# 63            99             2             1           103             2 

course_level_info <- course_level_info |>
  mutate(level = ifelse(str_detect(tolower(level), "und"),
                        "undergrad",
                        ifelse(str_detect(tolower(level),
                                          "both"),
                               "both", "grad")))
table(course_level_info$level)
# both      grad undergrad 
# 63       101       106

# What about the department?
length(unique(course_level_info$dept))
# [1] 163


# Now we'll categorize departments based on whether
# they contain "stat"
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

# Create bar chart display for courses taught by dept and level
# (This creates Figure 3 in the paper)
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
# [1] 142 

# How many classes didn't have available topics?
sum(is.na(course_level_info$topic_list))
# [1] 14
mean(is.na(course_level_info$topic_list))
# [1] 0.05185185

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
# (This creates Figure 4a in the paper)
topic_count_bars <- topic_counts |>
  mutate(class_topic = fct_reorder(class_topic, n_classes)) |>
  ggplot(aes(x = class_topic, y = n_classes)) +
  geom_bar(stat = "identity",
           fill = "black", color = "white") +
  coord_flip() +
  ylim(0, 114.3) +
  theme_light() +
  theme(plot.margin = margin(t = 5.5,
                             r = 8.5, 
                             b = 5.5, 
                             l = 5.5)) +
  labs(x = "",
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
#  6 networks                    31
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
# (This creates Figure 4b in the paper)
topic_count_hist <- course_level_info |>
  ggplot(aes(x = numTopics)) +
  geom_histogram(binwidth = 1, center = 0, closed = "left",
                 color = "white", fill = "black") +
  theme_light() +
  theme(panel.grid.minor.x = element_blank()) +
  ylim(0, 114.3) +
  labs(x = "Number of topics taught",
       y = "Number of courses") +
  scale_x_continuous(breaks = 0:10)
topic_count_hist
cowplot::save_plot("Paper2/Materials/figs/numTopics.pdf",
                   topic_count_hist, ncol = 1, nrow = 1)

#Proportion of courses that teach each number of topics:
prop.table(table(course_level_info$numTopics))
#How many (and what proportion) teach 2 or fewer topics?
sum(course_level_info$numTopics <= 2, na.rm = TRUE)
# [1] 226
mean(course_level_info$numTopics <= 2, na.rm = TRUE)
# [1] 0.8828125

# More closely examining which courses
# did not cover any of the topics:
courses_noTopics = subset(course_level_info, topic_list == "None",
                          select = c(name, dept))
print(courses_noTopics, n = 114)

# More closely examining which courses
# covered interactive graphics:
print(subset(course_level_info[which(topicChecks$interactive == 1),],
             select = c(name, dept)), n = 114)

# More closely examining which courses
# covered spatial data:
print(subset(course_level_info[which(topicChecks$spatial == 1),],
             select = c(name, dept)), n = 114)

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

# Create word clouds of departments
library(tidytext)
library(SnowballC)
data(stop_words)

#Among department names, count the number
#of times each word occurs.
#When doing this, also remove stop words
#and perform stemming. 
course_dept_text <- course_level_info |>
  dplyr::select(university, class, dept) |>
  unnest_tokens(word, dept) |>
  filter(!(word %in% stop_words$word)) |>
  group_by(word) |>
  mutate(word = wordStem(word)) %>%
  summarize(freq = n(), .groups = "drop")

library(wordcloud)
#Create a wordcloud of the top words
#that occur among department names.
#(This creates Figure 2 in the paper.)
set.seed(123)
wordcloud(words = course_dept_text$word,
          freq = course_dept_text$freq, 
          random.order = FALSE,
          max.words = 150, 
          min.freq = 3,
          rot.per = 0,
          colors = brewer.pal(8, "Dark2"))
