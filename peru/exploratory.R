# Exploratory data analysis

setwd('/home/williamn/Repository/financialAnalysis/peru')
listFiles <- list.files("cleanData", full.names = TRUE)

examples <- data.frame()
for(i in 1:length(listFiles)){
    tmp <- read.csv(listFiles[i])
    examples <- rbind(examples, tmp[which(tmp$year==2013),])
}

write.table(examples, file = "data.csv", sep = ",", quote = F, row.names = F)

# Plot of different ratios for all companies
datacl <- read.csv("data.csv")

library(ggplot2)
library(ggthemes)

ggplot(aes(x = ROA), data = datacl) + 
    geom_point(aes(y = REQ, color = Field)) + 
    theme_bw() + 
    coord_cartesian(xlim = c(-0.25, 0.28), ylim = c(-0.5, 1)) + 
    ggtitle("Exploratory analysis")



