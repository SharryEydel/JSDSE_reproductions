#Here we demonstrate viewing the bandwidth
#in a smoothed density plot as as an estimator.
#We can use the bootstrap
#to generate many different bandwidths.

#We'll consider the spotify dataset discussed in the paper:
spotify = read.csv("Paper2/Materials/data/datasets for examples/spotify.csv")

#generate 1000 bootstrapped datasets
set.seed(321)
bootData = list(length = 1000)
for(i in 1:1000){
	bootData[[i]] = spotify[sample(1:nrow(spotify),
		size = nrow(spotify), replace = TRUE),]
}
#compute binwidth for each bootstrapped dataset
bootBands = vector(length = 1000)
for(i in 1:1000){
	bootBands[i] = density(bootData[[i]]$loudness)$bw
}

#95% "interval" of smoothed density plots,
#where we plot the smoothed density using the
#mean, 2.5% quantile, and 97.5% quantile of the bandwidths.
#This generates Figure 6 from the paper.
library(tidyverse)
library(ggthemes)

lineCols = c("Avg." = colorblind_pal()(3)[1],
			"2.5% Quantile" = colorblind_pal()(3)[2],
			"97.5% Quantile" = colorblind_pal()(3)[3])
lineTypes = c("Avg." = 1,
			"2.5% Quantile" = 2,
			"97.5% Quantile" = 2)
names(lineCols) = factor(names(lineCols),
	levels = c("Avg.", "2.5% Quantile", "97.5% Quantile"))

bandwidthPlot = ggplot(spotify, aes(loudness)) +
	#average bandwidth
	stat_density(bw = mean(bootBands),
		geom = "line", position = "identity",
		aes(color = "Avg.", linetype = "Avg.")) +
	#lower 2.5% bandwidth
	stat_density(bw = as.numeric(quantile(bootBands, prob = 0.025)),
		geom = "line", position = "identity",
		aes(color = "2.5% Quantile", linetype = "2.5% Quantile")) +
	#upper 97.5% bandwidth
	stat_density(bw = as.numeric(quantile(bootBands, prob = 0.975)),
		geom = "line", position = "identity",
		aes(color = "97.5% Quantile", linetype = "97.5% Quantile")) +
	theme_light() +
	labs(x = "Loudness (dB)", y = "Density") +
	scale_colour_manual(name="Bandwidth Choice", values=lineCols,
		limits = c("Avg.", "2.5% Quantile", "97.5% Quantile")) +
	scale_linetype_manual(name="Bandwidth Choice", values=lineTypes,
		limits = c("Avg.", "2.5% Quantile", "97.5% Quantile"))
bandwidthPlot
cowplot::save_plot("Paper2/Materials/figs/bandwidthPlot.pdf",
                   bandwidthPlot, ncol = 1, nrow = 1)
