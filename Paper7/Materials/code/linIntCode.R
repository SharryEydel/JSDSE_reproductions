
#This example walks through how to 
#visually represent different linear regression models
#involving interaction terms.

#The example uses a dataset called electionData
#about mayoral elections in Louisiana from 1988-2011.
#We cannot publically distribute this dataset,
#but the below code can be adapted to any dataset
#with two quantitative and two categorical variables.
#Note that the below code WILL NOT RUN without access
#to electionData; code is shown here for demonstration purposes.

#Our example considers four variables:
# 1) female: whether any of the candidates in the election
#            were female (1 = yes, 0 = no).
# 2) africanAmerican: whether any of the candidates in the election
#            were African American (1 = yes, 0 = no).
# 3) unemp: Percentage of the municipality's population
#           that is unemployed.
# 4) voter_turnout: Percentage of eligible voters in
#           the municipality who voted in the election.
#We'll plot regressions of voter_turnout ~ unemp,
#where female and African American are used as covariates.


#First, make an example plot
#to obtain the legend (just for visualization purposes)
library(tidyverse)
library(ggthemes)

aplot = ggplot(electionData,
  aes(x = unemp, y = voter_turnout)) +
geom_point(aes(shape = africanAmerican, color = female)) +
scale_color_manual(values = c(
  "Yes" = colorblind_pal()(2)[2],
  "No" = colorblind_pal()(2)[1])) +
geom_smooth(method = lm, se = FALSE) +
theme_light() +
theme(legend.position = "bottom",
  plot.margin=unit(c(-5.5,5.5,-5.5,5.5), "pt")) +
  labs(title = "Plot 1",
    x = "Unemployment Rate (%)", y = "Voter Turnout (%)",
    color = "Female Candidate?",
    shape = "African American Candidate?")
aplot
#grab the legend
library(cowplot)
legend = get_plot_component(aplot,
  'guide-box-bottom', return_all = TRUE)

#plot1 code (from Figure 8)
plot1 = ggplot(electionData,
  aes(x = unemp, y = voter_turnout)) +
geom_point(aes(shape = africanAmerican, color = female),
  alpha = 0.35) +
scale_color_manual(values = c(
  "Yes" = colorblind_pal()(2)[2],
  "No" = colorblind_pal()(2)[1])) +
geom_smooth(method = lm, se = FALSE) +
theme_light() +
theme(legend.position = "none",
  plot.margin=unit(c(5.5,5.5,5.5,5.5), "pt")) +
  labs(title = "Plot 1",
    x = "Unemployment Rate (%)", y = "Voter Turnout (%)")
#plot2 code (from Figure 8)
plot2 = ggplot(electionData,
  aes(x = unemp, y = voter_turnout, shape = africanAmerican)) +
geom_point(aes(color = female),
  alpha = 0.5) +
scale_color_manual(values = c(
  "Yes" = colorblind_pal()(2)[2],
  "No" = colorblind_pal()(2)[1])) +
geom_smooth(method = lm, se = FALSE) +
theme_light() +
theme(legend.position = "none",
  plot.margin=unit(c(5.5,5.5,5.5,5.5), "pt")) +
  labs(title = "Plot 2",
    x = "Unemployment Rate (%)", y = "Voter Turnout (%)")
#plot3 code (from Figure 8)
plot3 = ggplot(electionData,
  aes(x = unemp, y = voter_turnout, color = female)) +
geom_point(aes(shape = africanAmerican),
  alpha = 0.5) +
scale_color_manual(values = c(
  "Yes" = colorblind_pal()(2)[2],
  "No" = colorblind_pal()(2)[1])) +
geom_smooth(method = lm, se = FALSE) +
theme_light() +
theme(legend.position = "none",
  plot.margin=unit(c(5.5,5.5,-5.5,5.5), "pt")) +
  labs(title = "Plot 3",
    x = "Unemployment Rate (%)", y = "Voter Turnout (%)")
#plot4 code (from Figure 8)
plot4 = ggplot(electionData,
  aes(x = unemp, y = voter_turnout,
    color = female, shape = africanAmerican)) +
geom_point(alpha = 0.5) +
scale_color_manual(values = c(
  "Yes" = colorblind_pal()(2)[2],
  "No" = colorblind_pal()(2)[1])) +
theme_light() +
theme(legend.position = "none",
  plot.margin=unit(c(5.5,5.5,-5.5,5.5), "pt")) +
geom_smooth(method = lm, se = FALSE) +
  labs(title = "Plot 4",
    x = "Unemployment Rate (%)", y = "Voter Turnout (%)")

library(gridExtra)
#arrange the plot (this creates Figure 8)
grid.arrange(plot1, plot2, plot3, plot4, legend,
  nrow = 3,
  widths = c(1,1,1),
  heights = c(1,1,0.25),
  layout_matrix = rbind(c(1,2),c(3,4),c(5,5)))
#example of R outplot from the fourth plot's model
#(This creates Table 3 in the paper)
summary(lm(voter_turnout ~ unemp*female*africanAmerican,
  data = electionData))
