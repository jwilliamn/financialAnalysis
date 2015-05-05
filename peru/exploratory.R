# Exploratory data analysis

setwd('/home/williamn/Repository/financialAnalysis/peru')
listFiles <- list.files("cleanData", full.names = TRUE)

examples <- data.frame()
for(y in 2013:2000){
    n <- 1
    for(i in 1:length(listFiles)){
        if(i == f28[n, 1] && n<dim(f28)[1]+1){
            tmp <- read.csv(listFiles[i])
            examples <- rbind(examples, tmp[which(tmp$year==y),])
            n <- n + 1
        }
    }
}

write.table(examples, file = "data.csv", sep = ",", quote = F, row.names = F)

# Plot of different ratios for all companies
datacl <- read.csv("data.csv")

library(ggplot2)
library(ggthemes)

ggplot(aes(x = ROA), data = datacl) + 
    geom_point(aes(y = REQ, color = Field)) + 
    theme_bw() + 
    coord_cartesian(xlim = c(-0.5, 0.8), ylim = c(-2.5, 2.5)) + 
    ggtitle("Exploratory analysis")

x <- datacl[,-(1:3)]
corMatrix <- cor(x)

# EFA

X <- read.csv("Xmn.csv")
Xn <- scale(X)
sigma <- cov(Xn)
R <- cor(Xn)
s <- svd(sigma)

eig <- eigen(sigma)

# PCA
library(psych)
require(GPArotation)

pc<- prcomp(Xn, scale=TRUE, center=TRUE)
summary(pc)


# Measure sampling adequacy
KMO(sigma)
cortest.bartlett(R, n = NULL)
det(R)

# Factor analysis
factors<- fa(R, nfactors=7, rotate="varimax", fm="ml")
factors
print(factors$loadings, cutoff = .3)
summary(factors)

nf<- factors$e.values
nf

# Decision trees
XnFrame<- data.frame(Xn)
ind<- sample(2, nrow(XnFrame), replace= TRUE, prob = c(0.7, 0.3))
trainData<- XnFrame[ind==1,]
testData<- XnFrame[ind==2,]
formulaREQ<- REQ ~ QRA + LRA + CRA + NWR + ATR + ETR + FAT + CAT + GPM + EBI + NPM + ROA + CAS + ICU + CEQ + STF + DER + LER + TFD
fit1<- rpart(formulaREQ, method = "class", data=trainData)
printcp(fit1)
plotcp(fit1)
summary(fit1)

library(party)
fit2<- ctree(formulaREQ, data=trainData)
plot(fit2)

library(tree)
fit4<- tree(formulaREQ, data=trainData)
plot(fit4)
text(fit4)
