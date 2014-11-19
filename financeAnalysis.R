# Financial Analysis

# Loading Data
setwd("/home/williamn/Repository/financialAnalysis")
data<- read.csv("companiesData.csv")
#idCia<- data[,2]; # subdata
dataFrame<- data.frame(data);

# Financial variables
revenue2013<- dataFrame$Revenue2013;
#revenue<- dataFrame[dataFrame$Revenue2013>5000000,]  # Subset all the data frame
totalAssets2013<- dataFrame$totalAssets2013;
totalLiabilities2013<- dataFrame$TotalLIabilities2013;
ownersEquity<- dataFrame$totalSHEQUITY2013;

# Ratios
debtRatio<- totalLiabilities2013/ownersEquity;
leverageRatio<- totalLiabilities2013/totalAssets2013;

# Exploratory factor analysis
#plot(totalLiabilities2013,totalAssets2013, xlab="Liabilities", ylab="Assets");
#abline(lm(totalAssets2013 ~ totalLiabilities2013));
plot(debtRatio, leverageRatio, xlab="Debt", ylab="Leverage");
