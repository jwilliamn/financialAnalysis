# Data cleaning

setwd('/home/williamn/Repository/financialAnalysis/peru')
listFiles <- list.files("data", full.names = TRUE)
etna <- read.csv('etna.csv')
etna <- as.data.frame(t(etna))
write.table(etna, file = "netna.csv", sep = ",")
for(i in 1:68){
    name <- listFiles[i]
    tmp <- read.csv(listFiles[i])
    tmp <- as.data.frame(t(tmp))
    tmp <- tmp[-1, ]
    write.table(tmp, file = name, sep = ",")
}

# Check whether the file has all the required variables
check <- data.frame()
for(i in 1:68){
    tmp<- read.csv(listFiles[i])
    check <- rbind(check, c(i, dim(tmp)[1], dim(tmp)[2]))
}

# Subsetting the 3 different groups of variables found
f177 <- check[check$X177L == 177,]
f128 <- check[check$X177L == 128,]
f263 <- check[check$X177L == 263,]

# Rearrange the raw data into usable data for the analysis
for(j in 1:dim(f128)[1]){
    tmp <- 
}

# Further analysis for one company "Acumuladores Etna"
netna <- read.csv('netna.csv')
library(ggplot2)
library(ggthemes)

qplot(x = c(1:22), y =V71, data = netna)
