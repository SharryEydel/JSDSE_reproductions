
#This example demonstrates how to run a visual
#randomization test with areal map data.

library(tidyverse)
library(ggmap)

#We'll consider the ACS data considered in the paper:
acs = read.csv("Paper2/Materials/data/datasets for examples/acs2015.csv")

#First we get border information for all states
state.data = map_data("state")

#Now we'll filter out Alaska, Hawaii, and Puerto Rico
#from the acs data (just for ease of visualization)
acs = subset(acs, State != "Alaska" & State != "Hawaii" & State != "Puerto Rico")

#Compute the weighted mean across counties:
acs.stateWeightedMean = acs %>% group_by(State) %>%
  summarize(meanUnemployment = sum(TotalPop*Unemployment)/sum(TotalPop) )

#In order to match the state data, we need to convert
#the state name to lower case in the ACS dataset.
acs.stateWeightedMean$State = tolower(acs.stateWeightedMean$State)

## Sharry's added code:
length(acs) # 37

#Now we can merge the two datasets
acs.stateWeightedMean.merged = state.data %>% left_join(acs.stateWeightedMean, by = c("region" = "State"))

# Plot of states, colored by average unemployment rate
realMap = ggplot(acs.stateWeightedMean.merged) +
  geom_polygon(aes(x = long, y = lat, group = group, fill = meanUnemployment), 
               color = "black") + 
  scale_fill_gradient2(high = "darkred", low = "darkblue", 
                       mid = "white",
                       midpoint = median(acs.stateWeightedMean$meanUnemployment)) +
  theme_void() +
  theme(legend.position="bottom",
    plot.margin = unit(c(-3, -1, -3, -1), 
                                "inches")) +
  coord_map("polyconic") + 
  labs(title = "",
       fill = "Unemployment Rate (%)")
#Thus, this is the real map from Figure 7 in the paper:
realMap

#Now we'll generate many randomized maps.
#To do this, we'll use a function to create a map
#for a given (possibly shuffled) dataset.
getStateMap.unemp = function(data){
  plot = ggplot(data) +
  geom_polygon(aes(x = long, y = lat, group = group, fill = meanUnemployment), 
               color = "black") + 
  scale_fill_gradient2(high = "darkred", low = "darkblue", 
                       mid = "white",
                       midpoint = median(acs.stateWeightedMean$meanUnemployment)) +
  theme_void() +
  theme(legend.position = "none",
    plot.margin = unit(c(-1, 0, -1, 0), 
                                "inches")) +
  coord_map("polyconic")
  return(plot)
}

#Now we're going to permute (i.e., "shuffle")
#the outcomes a few times.
#number of randomizations/permutations/shuffles:
rands = 25

set.seed(123)
plotList = list(length = rands)
for(r in 1:rands){
  #create a "randomized" dataset
  acs.stateWeightedMean.merged.rand = acs.stateWeightedMean.merged
  #shuffle the outcomes
  acs.stateWeightedMean.merged.rand$meanUnemployment = sample(acs.stateWeightedMean.merged.rand$meanUnemployment)
  #create the plot and store it
  plotList[[r]] = getStateMap.unemp(acs.stateWeightedMean.merged.rand)
}

#pick a random entry of plotList to be the "real" plot
plotList[[sample(1:rands, size = 1)]] = getStateMap.unemp(acs.stateWeightedMean.merged)

#plot all the plots together
#(this creates Figure 7 in the paper)
#first, grab the legend from the real map
library(cowplot)
legend = get_plot_component(realMap, 'guide-box-bottom', return_all = TRUE)
library(grid)
library(gridExtra)
grid.arrange(
  plotList[[1]], plotList[[2]], plotList[[3]], plotList[[4]],
  plotList[[5]], plotList[[6]], plotList[[7]], plotList[[8]],
  plotList[[9]], plotList[[10]], plotList[[11]], plotList[[12]],
  plotList[[13]], plotList[[14]], plotList[[15]], plotList[[16]],
  plotList[[17]], plotList[[18]], plotList[[19]], plotList[[20]],
  plotList[[21]], plotList[[22]], plotList[[23]], plotList[[24]],
  plotList[[25]],
  legend, nrow = 5,
  vp=viewport(width=1.05, height=1.05, clip = TRUE),
  layout_matrix = rbind(1:5, 6:10, 11:15, 16:20, 21:25,
    c(26,26,26,26,26)))
#We can see that the real map
#is on the far-right of the second row.

