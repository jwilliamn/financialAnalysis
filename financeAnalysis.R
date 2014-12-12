# Financial Analysis
# We use the principal factor analysis and the decision tree approach

# Loading Data
setwd("/home/williamn/Repository/financialAnalysis")
data<- read.csv("energyCias2013.csv")
dataFrame<- data.frame(data)

# Financial variables
revenue<- dataFrame$revenue
costOfRevenue<- dataFrame$costOfRevenue
grossProfit<- dataFrame$grossProfit
operatingIncome<- dataFrame$operatingIncome
earningsBIT<- dataFrame$earningsBIT
interestExpense<- dataFrame$interestExpense
netIncome<- dataFrame$netIncome
cashEquivalents<- dataFrame$cashEquivalents
netReceivables<- dataFrame$netReceivables
inventory<- dataFrame$inventory
currentAssets<- dataFrame$currentAssets
longTermInvestments<- dataFrame$longTermInvestments
fixedAssets<- dataFrame$fixedAssets
totalAssets<- dataFrame$totalAssets
shortTermDebt<- dataFrame$shortTermDebt
currentLiabilities<- dataFrame$currentLiabilities
longTermDebt<- dataFrame$longTermDebt
totalLiabilities<- dataFrame$totalLiabilities
totalSHEquity<- dataFrame$totalSHEquity
netTangibleAs<- dataFrame$netTangibleAs

# Ratios
# Liquidity ratios
QRA<- (currentAssets - inventory)/currentLiabilities # quick ratio
LRA<- currentAssets/currentLiabilities # liquidity ratio
CRA<- cashEquivalents/currentLiabilities # cash ratio

# Asset utilization or turnover ratios
RTR<- revenue/netReceivables # receivableTurnonverRatio
ITR<- costOfRevenue/inventory # inventoryTurnonverRatio
NWR<- revenue/(currentAssets - currentLiabilities) # nwcTurnonverRatio
ATR<- revenue/totalAssets # assetTurnonverRatio
ETR<- revenue/totalSHEquity # equityTurnonverRatio
FAT<- revenue/fixedAssets # fixedAssetTurnonverRatio
LTA<- revenue/longTermInvestments # longTermAssetTurnonverRatio
CAT<- revenue/currentAssets # currentAssetTurnonverRatio

# Profitability ratios
GPM<- grossProfit/revenue # grossProfitMargin
EBI<- earningsBIT/revenue # ebitMargin
NPM<- netIncome/revenue # netProfitMargin
REQ<- netIncome/totalSHEquity # returnOnEquity
ROA<- netIncome/totalAssets # returnOnAssets

# Asset structure ratios
CAS<- currentAssets/totalAssets # currentAssetToTotalAssetRatio
ICU<- inventory/currentAssets # inventoryToCurrentAssetRatio
CEQ<- cashEquivalents/currentAssets # cashEquivToCurrentAssetRatio
LTE<- longTermInvestments/totalAssets # longTermToAssetRatio

# Solvency ratios
STF<- shortTermDebt/totalLiabilities # shortTermFinanDebtToTotalDebt
STD<- currentLiabilities/totalLiabilities # shortTermDebtToTotalDebt
ICR<- earningsBIT/interestExpense # interestCoverageRatio
DER<- totalLiabilities/totalSHEquity # debtRatio
LER<- totalLiabilities/totalAssets # leverageRatio
TFD<- (shortTermDebt + longTermDebt)/totalLiabilities # totalFinanDebtToTotalDebt

# Matrix of data with the ratios as variables
X<- cbind(QRA, LRA, CRA, RTR, ITR, NWR, ATR, ETR, FAT, LTA, CAT, GPM, EBI, NPM, 
          REQ, ROA, CAS, ICU, CEQ, LTE, STF, STD, ICR, DER, LER, TFD)

# Feature normalization
Xn<- scale(X)

# Exploratory factor analysis
# Compute correlation matrix
corMatrix<- cor(Xn)

# Plot of the correlation matrix
image(c(1:26), c(1:26), corMatrix, col=gray((32:0)/32), 
      xlab="", ylab="", main="Correlation matrix - financial ratios")

# Compute preliminary estimates hi~^2 of the communalities hi^2
diag<- diag(rep(1,26))
diag
cor.min <- corMatrix - diag
cor.min
h2 <- apply(abs(cor.min), 2, max)
h2

# Compute eigenvalues and eigenvectors of reduced correlation matrix
cor.reduced <- cor.min + diag(h2)
cor.reduced
eig <- eigen(cor.reduced)
eig

# Consideremos nuestro modelo para k=10
#pf10 <- eig$vectors[,1:10] %*% diag(eig$values[1:10]^{1/2});
#pf10
# h^2:
#pf10^2;

# Consideremos el modelo para k=8
pf <- eig$vectors[,1:8] %*% diag(eig$values[1:8]^{1/2})
pf
# h^2:
apply(pf^2, 1, sum)

# Actualizamos la estimacion para los "communalities"
for (i in 1:100){
    h2 <- apply(pf^2, 1, sum)
    cor.reduced <- cor.min + diag(h2)
    eig <- eigen(cor.reduced)
    pf <- eig$vectors[,1:8] %*% diag(eig$values[1:8]^{1/2})
}
pf
h2

# Veamos si la condicion 2 se satisface
round(t(pf) %*% pf, 26) # Matrix of factors with diagonal decreasing

# Veamos si Lambda*Lambda' + Psi se acerca a la matrix de correlacion
fit <- pf %*% t(pf) + diag(1-h2)
fit
#cor(scor)
round(corMatrix-fit, 26) # should be close to zero

# Using other methods of factor analysis to compare results
# compare with PCA
pc<- prcomp(Xn, scale=TRUE, center=TRUE)
summary(pc)
loadings(pc)
plot(pc, type = "lines")
pc$scores # the principal componentes
biplot(pc)

# Factor analysis using Factanal (Maximun Likelihood factor analysis)
fal<- factanal(Xn, 4, rotation="varimax") # this method has failed
print(fal, cutoff=.3)

# fa() procedure to perform factor analysis
library(psych)
require(GPArotation)
factors<- fa(corMatrix, nfactors=8, rotate="varimax", fm="ml")
factors
print(factors$loadings, cutoff = .3)
summary(factors)

# Number of factors to retain
# Kaiser criterion
nf<- factors$e.values
nf

# Scree plot
scree(corMatrix, main = "Number of factors - Scree plot")
fa.parallel(corMatrix)

# Visualization of the factors
fa.diagram(factors, main = "Observed variables and unobserved factors")

# Using nFactors package
library(nFactors)
ev <- eigen(corMatrix)
ap <- parallel(subject=nrow(Xn),var=ncol(Xn),
               rep=100,cent=.05)
nS <- nScree(x=ev$values, aparallel=ap$eigen$qevpea)
plotnScree(nS, main = "Non Graphical Solutions to Scree Test - nFactors")
