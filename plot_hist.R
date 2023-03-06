library(ggplot2)

ctrl <- read.table("CTRLfinalMatwMeans.tab", header = TRUE)
kd <- read.table("KDfinalMatwMeans.tab", header = TRUE)


ggplot(kd[kd$MeanRatio!= 1,], aes(x=MeanRatio)) + geom_histogram(binwidth = .1) +
  theme_classic() +
  labs(title = "Control Mean Editing Ratio")
ggplot(ctrl[ctrl$MeanRatio != 1,], aes(x=MeanRatio)) + geom_histogram(binwidth = .1) +
  theme_classic() +
  labs(title = "KD Mean Editing Ratio")
