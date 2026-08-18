
#This example considers visualizing PCA.

#We'll consider the spotify dataset discussed in the paper:
spotify = read.csv("Paper2/Materials/data/datasets for examples/spotify.csv")

#for ease of display, change "duration_ms" to just "duration"
names(spotify)[which(names(spotify) == "duration_ms")] = "duration"

#First, define principal components
#To do this, only focus on the 11 quantitative variables:
spotify.subset = subset(spotify, select = -c(year, decades))

## Sharry's Code:
length(spotify) # 13

#now run PCA
spotify.pca = prcomp(spotify.subset,
	center = TRUE, scale. = TRUE)

#now make a biplot on the first two principal components
#This creates Figure 9a in the paper.
library(ggbiplot)
library(ggrepel)
biplot = ggbiplot(spotify.pca,
	scale = 0,
	point.size = 1.5,
	alpha = 0.3,
	groups = spotify$decades,
	varname.size = 5,
	varname.adjust = 1.5,
	varname.color = adjustcolor( "white", alpha.f = 0)
	) +
	scale_colour_brewer(type = "seq", palette = "Spectral") +
	scale_fill_brewer(type = "seq", palette = "Spectral") +
	geom_point(aes(fill = spotify$decades),
		color = "black", pch = 21, size = 2, alpha = 0.3) +
	theme_light() +
	labs(color = "Decades", fill = "Decades",
		x = "First Principal Component (57.5% Variance Explained)",
		y = "Second Principal Component (18.8% Variance Explained)") +
	annotate("text", x=-0.6, y=-1.8, label= "speechiness",
		size = 4, color = adjustcolor("black", alpha.f = 0.7)) +
	annotate("text", x=0.25, y=-1.6, label= "valence",
		size = 4, color = adjustcolor("black", alpha.f = 0.7)) +
	annotate("text", x=1.35, y=-1.45, label= "danceability",
		size = 4, color = adjustcolor("black", alpha.f = 0.7)) +
	annotate("text", x=1.5, y=-0.375, label= "tempo",
		size = 4, color = adjustcolor("black", alpha.f = 0.7)) +
	annotate("text", x=1.65, y=0, label= "energy",
		size = 4, color = adjustcolor("black", alpha.f = 0.7)) +
	annotate("text", x=1.6, y=0.375, label= "popularity",
		size = 4, color = adjustcolor("black", alpha.f = 0.7)) +
	annotate("text", x=1.65, y=0.2, label= "loudness",
		size = 4, color = adjustcolor("black", alpha.f = 0.7)) +
	annotate("text", x=0.7, y=1.525, label= "duration",
		size = 4, color = adjustcolor("black", alpha.f = 0.7)) +
	annotate("text", x=-2.1, y=0.35, label= "instrumentalness",
		size = 4, color = adjustcolor("black", alpha.f = 0.7)) +
	annotate("text", x=-2, y=0.05, label= "acousticness",
		size = 4, color = adjustcolor("black", alpha.f = 0.7)) +
	annotate("text", x=-0.6, y=-0.3, label= "liveness",
		size = 4, color = adjustcolor("black", alpha.f = 0.7))
#change color of arrows
biplot$layers[[2]]$aes_params$colour = adjustcolor( "black", alpha.f = 0.5)
biplot


#elbow plot
#(this creates Figure 9b in the paper)
elbowPlot = ggscreeplot(spotify.pca) + 
	labs(x = "Principal Component Number",
		y = "Variance Explained") +
	theme_light() +
	coord_cartesian(ylim = c(0, 0.572)) +
	scale_x_continuous(breaks = 1:11, minor_breaks = 1:11)
elbowPlot

#table of first two columns of rotation matrix
#(organized in alphabetical order)
library(knitr)

#get the "rotation" from PCA:
rotation.pca = as.matrix(spotify.pca$rotation)

#This displays Table 4 in the paper
kable(round(rotation.pca[
	c("acousticness", "danceability", "duration",
		"energy", "instrumentalness", "liveness",
		"loudness", "popularity",
		"speechiness", "tempo", "valence"),1:2], digits = 3),
"latex")
