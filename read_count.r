#!/usr/bin/env Rscript
library(ggplot2)


file  = as.character(args[1])

df <- read.csv(file)

p <- (ggplot(df, aes(x=as.factor(Type), y=Read_Count, fill=as.factor(Type))) 
      + geom_bar(stat="identity", color="Black", width = 0.7)
      + scale_fill_brewer(palette = "Set1")
      + xlab("Data Type")
      + ylab("Read Count")
      + ggtitle("Read Count Comparison in our U87MG Dataset")
      + geom_text(aes(label = signif(Read_Count)), nudge_y = 1500000)
      + theme_classic()
      + theme(plot.title = element_text(size = 15, face = "bold"), legend.position = "none", axis.title = element_text(size = 13), axis.text.x = element_text(size = 12)))
plot(p)

dev.off()
