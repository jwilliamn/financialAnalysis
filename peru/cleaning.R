# Data cleaning

setwd('/home/williamn/Repository/financialAnalysis/peru')
listFiles <- list.files("data", full.names = TRUE)
#etna <- read.csv('etna.csv')
#etna <- as.data.frame(t(etna))
#write.csv(etna, file = "etnat.csv")
for(i in 1:70){
    name<- listFiles[i]
    tmp <- read.csv(listFiles[i])
    tmpt <- as.data.frame(t(tmp))
    write.csv(tmpt, file = name)
}
