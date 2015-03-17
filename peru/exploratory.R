# Exploratory data analysis

setwd('/home/williamn/Repository/financialAnalysis/peru')
listFiles <- list.files("cleanData", full.names = TRUE)

examples <- data.frame()
for(i in 1:80){
    tmp <- read.csv(listFiles[i])
    examples <- rbind(examples, tmp[which(tmp$year==2013),])
}

write.table(examples, file = "data.csv", sep = ",", quote = F, row.names = F)

# Plot of different ratios for all companies
data <- read.csv("data.csv")
plot(data$ROA, data$REQ)


