
#Here we demonstrate that graphics may look the same, but
#the statistical inference may look very different
#(largely because of sample size/uncertainty).

#function that displays a barplot with confidence intervals
#for any dataframe with (A, B, C) categories.
getBarplot = function(n,
	props = c(0.25, 0.35, 0.4),
	displayCIs = FALSE, adjustCIs = FALSE,
	alpha = 0.05,
	ylimMax = 0.6){
	#first, check to make sure that
	#each n*p is a whole number
	#(such that it's a proper barplot)
	if( sum((n*props)%%1 == 0) < 3 ){
		return(print("n times trueProps must be whole numbers."))
	}
	if( sum(props) != 1 ){
		return(print("total props must equal 1."))
	}
	#proportions
	propA = props[1]; propB = props[2]; propC = props[3]
	#create dataset
	data = data.frame(cat = c(
		rep("A", n*propA),
		rep("B", n*propB),
		rep("C", n*propC)))

	#If the CIs are Bonferroni-adjusted,
	#then adjust the alpha value
	if(adjustCIs){alpha = alpha/3}
	
	#Calculate proportions and confidence intervals
	data.summary = data %>%
	  count(cat) %>%
	  mutate(
	    proportion = n / sum(n),
	    n_total = sum(n),
	    se = qnorm(1-alpha/2)*sqrt((proportion*(1 - proportion))/n_total),
	    lower = proportion - se,
	    upper = proportion + se)
	
	#create barplot
	barplot = ggplot(data.summary, aes(x = cat, y = proportion)) +
	  geom_col(fill = "white", color = "black") +
	  theme_light() +
	  theme(panel.grid.major.x = element_blank()) +
	  ylim(0, ylimMax) +
	  #add sample size and p-value from overall chi-squared test
	  labs(x = "", y = "")
	
	#display CIs?
	if(displayCIs){
		if(adjustCIs){
			#if adjusted, add to title, and make CIs orange
			barplot = barplot +
			labs(title = paste0("n = ", n,
	  		", p-value = ",
	  		round(chisq.test(table(data$cat))$p.value, digits = 2),
	  		", Adjusted CIs")) +
			geom_errorbar(aes(ymin = lower, ymax = upper), width = 0.5,
				color = colorblind_pal()(2)[2])
		} else{
			#if unadjusted, add to title, and make CIs black
			barplot = barplot +
			labs(title = paste0("n = ", n,
	  		", p-value = ",
	  		round(chisq.test(table(data$cat))$p.value, digits = 2),
	  		", Undjusted CIs")) +
			geom_errorbar(aes(ymin = lower, ymax = upper), width = 0.5,
				color = colorblind_pal()(2)[1])
		}
	}
	return(barplot)
}

#example plot
library(tidyverse)
library(ggthemes)

barplot1 = getBarplot(n = 40,
	props = c(0.25, 0.35, 0.4),
	displayCIs = TRUE, adjustCIs = FALSE, alpha = 0.05)
barplot1

#Now we'll compute the significance
#of chi-squared test as a function of sample size
n.vec = seq(20, 1000, by = 20)
chisq.pvalue = (length = length(n.vec))
#we'll also consider significance of a pairwise test
#between A and B, and A and C.
#Specifically, we'll compute whether 0 is
#inside the CI for the difference in proportions.
#Because these differences are always negative,
#we'll only compute the upper bound.
ciAB = (length = length(n.vec))
ciAC = (length = length(n.vec))
#We'll also compute Bonferroni-corrected CIs:
ciAB.bonf = (length = length(n.vec))
ciAC.bonf = (length = length(n.vec))
for(n in n.vec){
	props = c(0.25, 0.35, 0.4)
	#chi-squared test
	chisq.pvalue[n/n.vec[1]] = 
	chisq.test(c(n*props[1],n*props[2],n*props[3]),
		p = rep(1/3, 3))$p.value
	#proportions
	propA = props[1]; propB = props[2]; propC = props[3]
	#CI upper bound for difference between A and B.
	diffAB = propA - propB
	seAB = sqrt( propA*(1-propA)/n + propB*(1-propB)/n 
		+ 2*propA*propB/n 
		)
	ciAB[n/n.vec[1]] = diffAB + qnorm(1-0.05/2)*seAB
	ciAB.bonf[n/n.vec[1]] = diffAB + qnorm(1-(0.05/3)/2)*seAB
	#CI upper bound for difference between A and C.
	diffAC = propA - propC
	seAC = sqrt( propA*(1-propA)/n + propC*(1-propC)/n 
		+ 2*propA*propC/n 
		)
	ciAC[n/n.vec[1]] = diffAC + qnorm(1-0.05/2)*seAC
	ciAC.bonf[n/n.vec[1]] = diffAC + qnorm(1-(0.05/3)/2)*seAC
}

# CODE TO GENERATE PLOTS IN FIGURE 5 FROM PAPER
# 1) overall chi-squared test fails to reject,
#    and all CIs overlap
#(plot a in Figure 5)
barplot1 = getBarplot(n = 40, props = c(0.25, 0.35, 0.4),
	displayCIs = TRUE, adjustCIs = FALSE, alpha = 0.05)
barplot1
#same plot, corrected for multiple testing
#(plot d in Figure 5)
barplot4 = getBarplot(n = 40, props = c(0.25, 0.35, 0.4),
	displayCIs = TRUE, adjustCIs = TRUE, alpha = 0.05)
barplot4
#note that this CI fails to reject regardless of whether
#one accounts for multiple testing
ciAC[n.vec == 40]
ciAC.bonf[n.vec == 40]

# 2) overall chi-squared test fails to reject,
#    all CIs overlap, and at least one pairwise test reject
#(plot b in Figure 5)
barplot2 = getBarplot(n = 120, props = c(0.25, 0.35, 0.4),
	displayCIs = TRUE, adjustCIs = FALSE, alpha = 0.05)
barplot2
#same plot, corrected for multiple testing
#(plot e in Figure 5)
barplot5 = getBarplot(n = 120, props = c(0.25, 0.35, 0.4),
	displayCIs = TRUE, adjustCIs = TRUE, alpha = 0.05)
barplot5
#note that this CI rejects when NOT accounting for 
#multiple testing, but otherwise fails to reject.
ciAC[n.vec == 120]
ciAC.bonf[n.vec == 120]

# 3) overall chi-squared test rejects,
#    and at least one pairwise test rejects.
#(plot c in Figure 5)
barplot3 = getBarplot(n = 200,
	props = c(0.25, 0.35, 0.40),
	displayCIs = TRUE, adjustCIs = FALSE, alpha = 0.05)
barplot3
#the same plot, but corrected for multiple testing
#(plot f in Figure 5)
barplot6 = getBarplot(n = 200,
	props = c(0.25, 0.35, 0.40),
	displayCIs = TRUE, adjustCIs = TRUE, alpha = 0.05)
barplot6
#note that this CI rejects regardless of whether
#one accounts for multiple testing
ciAC[n.vec == 200]
ciAC.bonf[n.vec == 200]

#Arrange all six plots in a grid
library(patchwork)
(barplot1 + barplot2 + barplot3)/(barplot4 + barplot5 + barplot6)




