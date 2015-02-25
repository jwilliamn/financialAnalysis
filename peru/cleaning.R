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
# f127
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
    colnames(arranged) <- c("year", "V2", "V3", "V5", "V7", "V10", "V19", "V26", 
                            "V27", "V34", "V35", "V38", "V39", "V40", "V37", "V47", 
                            "Cpp", "V57", "V71", "V72", "V73", 
                            "V79", "V85", "V86", "V91")
    write.table(arranged, file = name, sep = ",")
}

# f176
for(j in 1:dim(f176)[1]){
    arranged <- data.frame()
    name <- listFiles[f176[j,1]]
    tmp <- read.csv(listFiles[f176[j,1]])
    # getting the year
    syear <- substrRight(row.names(tmp)[1], 4)
    nyear <- as.numeric(syear)
    year <- c()
    for(i in 1:length(row.names(tmp))){
        year <- c(year, nyear-1+i)
    }
    arranged <- cbind(year, tmp$V2, tmp$V3, tmp$V5, tmp$V7, tmp$V10, tmp$V19, 
                      tmp$V26, tmp$V27, tmp$V34, tmp$V35, tmp$V38, tmp$V39, 
                      tmp$V40, tmp$V37, tmp$V47, tmp$V48, tmp$V49, tmp$V50, 
                      tmp$V51, tmp$V57, tmp$V71, tmp$V72, tmp$V73, tmp$V79, 
                      tmp$V85, tmp$V86, tmp$V91)
    colnames(arranged) <- c("year", "V2", "V3", "V5", "V7", "V10", "V19", "V26", 
                            "V27", "V34", "V35", "V38", "V39", "V40", "V37", "V47", 
                            "V48", "V49", "V50", "V51", "V57", "V71", "V72", "V73", 
                            "V79", "V85", "V86", "V91")
    write.table(arranged, file = name, sep = ",")
}

# f262
for(j in 1:dim(f262)[1]){
    arranged <- data.frame()
    name <- listFiles[f262[j,1]]
    tmp <- read.csv(listFiles[f262[j,1]])
    # getting the year
    syear <- substrRight(row.names(tmp)[1], 4)
    nyear <- as.numeric(syear)
    year <- c()
    for(i in 1:length(row.names(tmp))){
        year <- c(year, nyear-1+i)
    }
    arranged <- cbind(year, tmp$V2, tmp$V3, tmp$V4, tmp$V31, tmp$V1, tmp$V14, 
                      tmp$V48, tmp$V49, tmp$V60, tmp$V61, tmp$V81, tmp$V75, 
                      tmp$V86, tmp$V87, tmp$V88, tmp$V89, tmp$V90, tmp$V106, 
                      tmp$V132, tmp$V1, tmp$V1, tmp$V202, tmp$V210, tmp$V212, 
                      tmp$V213)
    colnames(arranged) <- c("year", "V2", "V3", "V5", "V7", "V10", "V19", "V26", 
                            "V27", "V34", "V35", "Cpp", "V37", "V47", "V48", "V49", "V50",
                            "V51", "V57", "V71", "V72", "V73", "V79", "V85", "V86", 
                            "V91")
    write.table(arranged, file = name, sep = ",")
}

# Further analysis for one company "Acumuladores Etna"
netna <- read.csv('netna.csv')
library(ggplot2)
library(ggthemes)

qplot(x = c(1:22), y =V71, data = netna)
