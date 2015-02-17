# Data cleaning

setwd('/home/williamn/Repository/financialAnalysis/peru')
list.files()
etna<- read.csv('etna.csv')
etna<- as.data.frame(t(etna))
write.csv(etna, file = "etnat.csv")