# Data cleaning

setwd('/home/williamn/Repository/financialAnalysis/peru')
listFiles <- list.files("data", full.names = TRUE)

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
check$X176L <- factor(check$X176L)

# Subsetting the 3 different groups of variables found
f176 <- check[check$X176L == 176,]
f127 <- check[check$X176L == 127,]
f262 <- check[check$X176L == 262,]

# Function to get the year using substr and nchar
substrRight <- function(x, n){
    substr(x, nchar(x)-n+1, nchar(x))
}

# Rearrange the raw data into usable data for the analysis
for(j in 1:dim(f127)[1]){
    arranged <- data.frame()
    name <- listFiles[f127[j,1]]
    tmp <- read.csv(listFiles[f127[j,1]])
    # getting the year
    syear <- substrRight(row.names(tmp)[1], 4)
    nyear <- as.numeric(syear)
    year <- c()
    for(i in 1:length(row.names(tmp))){
        year <- c(year, nyear-1+i)
    }
    arranged <- cbind(year, tmp$V2, tmp$V3, tmp$V4, tmp$V12, tmp$V1, tmp$V20, 
                      tmp$V27, tmp$V28, tmp$V38, tmp$V39, tmp$V41, tmp$V42, 
                      tmp$V43, tmp$V44, tmp$V51, tmp$V54, tmp$V61, tmp$V80, 
                      tmp$V1, tmp$V94, tmp$V107, tmp$V110, tmp$V112, tmp$V117)
    colnames(arranged) <- c("year", "V2", "V3", "V5", "")
    write.table(arranged, file = name, sep = ",")
}

# Further analysis for one company "Acumuladores Etna"
netna <- read.csv('netna.csv')
library(ggplot2)
library(ggthemes)

qplot(x = c(1:22), y =V71, data = netna)
