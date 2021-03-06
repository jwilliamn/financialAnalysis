# Data cleaning

setwd('/home/williamn/Repository/financialAnalysis/peru')
listFiles <- list.files("rawData", full.names = TRUE)
listTemp <- list.files("test", full.names = TRUE)


for(i in 1:length(listFiles)){
    name <- listFiles[i]
    tmp <- read.csv(listFiles[i])
    tmp <- as.data.frame(t(tmp))
    tmp <- tmp[-1, ]
    write.table(tmp, file = name, sep = ",")
}

# Check whether the file has all the required variables
check <- data.frame()
for(i in 1:length(listTemp)){
    tmp <- read.csv(listTemp[i])
    check <- rbind(check, c(i, dim(tmp)[1], dim(tmp)[2]))
}
check$X127L <- factor(check$X127L)

# Subsetting the 3 different groups of variables found
f127 <- check[check$X127L == 127,]
f176 <- check[check$X127L == 176,]
f262 <- check[check$X127L == 262,]

# Names of companies
names <- c()
for(k in 1:dim(f176)[1]){
    names <- c(names, listTemp[f176[k,1]])
}

# Function to get the year using substr and nchar
substrRight <- function(x, n){
    substr(x, nchar(x)-n+1, nchar(x))
}

# Rearrange the raw data into usable data for the analysis
m <- 1
n <- 1
p <- 1
for(i in 1:length(listFiles)){
    arranged <- data.frame()
    name <- listFiles[i]
    tmp <- read.csv(listFiles[i])
    # getting the year
    syear <- substrRight(row.names(tmp)[1], 4)
    nyear <- as.numeric(syear)
    year <- c()
    for(j in 1:length(row.names(tmp))){
        year <- c(year, nyear-1+j)
    }
    # changing "-" to "0"
    f <- sapply(tmp, is.factor)
    for(c in 1:dim(tmp)[2]){
        if(f[c] == T){
            levels(tmp[, c])[levels(tmp[, c]) == "-"] <- "0"
        }
    }
    # f127
    if(i == f127[m, 1] && m<dim(f127)[1]+1){
        arranged <- cbind.data.frame(year, tmp$V2, tmp$V3, tmp$V4, tmp$V12, rep(0, dim(tmp)[1]), tmp$V20, 
                                     tmp$V27, tmp$V28, tmp$V38, tmp$V39, tmp$V41, tmp$V42, 
                                     tmp$V43, tmp$V44, tmp$V51, tmp$V54, tmp$V61, tmp$V80, 
                                     rep(0, dim(tmp)[1]), tmp$V94, tmp$V107, tmp$V110, tmp$V112, tmp$V117)
        colnames(arranged) <- c("year", "V2", "V3", "V5", "V7", "V10", "V19", "V26", 
                                "V27", "V34", "V35", "V38", "V39", "V40", "V37", "V47", 
                                "Cpp", "V57", "V71", "V72", "V73", 
                                "V79", "V85", "V86", "V91")
        m <- m+1
    }
    # f176
    if(i == f176[n, 1] && n<dim(f176)[1]+1){
        arranged <- cbind.data.frame(year, tmp$V2, tmp$V3, tmp$V5, tmp$V7, tmp$V10, tmp$V19, 
                                     tmp$V26, tmp$V27, tmp$V34, tmp$V35, tmp$V38, tmp$V39, 
                                     tmp$V40, tmp$V37, tmp$V47, tmp$V48, tmp$V49, tmp$V50, 
                                     tmp$V51, tmp$V57, tmp$V71, tmp$V72, tmp$V73, tmp$V79, 
                                     tmp$V85, tmp$V86, tmp$V91)
        colnames(arranged) <- c("year", "V2", "V3", "V5", "V7", "V10", "V19", "V26", 
                                "V27", "V34", "V35", "V38", "V39", "V40", "V37", "V47", 
                                "V48", "V49", "V50", "V51", "V57", "V71", "V72", "V73", 
                                "V79", "V85", "V86", "V91")
        n <- n+1
    }
    # f262
    if(i == f262[p, 1] && p<dim(f262)[1]+1){
        arranged <- cbind.data.frame(year, tmp$V2, tmp$V3, tmp$V4, tmp$V31, rep(0, dim(tmp)[1]), tmp$V14, 
                                     tmp$V48, tmp$V49, tmp$V60, tmp$V61, tmp$V81, tmp$V75, 
                                     tmp$V86, tmp$V87, tmp$V88, tmp$V89, tmp$V90, tmp$V106, 
                                     tmp$V132, rep(0, dim(tmp)[1]), tmp$V132, tmp$V202, tmp$V210, tmp$V212, 
                                     tmp$V213)
        colnames(arranged) <- c("year", "V2", "V3", "V5", "V7", "V10", "V19", "V26", 
                                "V27", "V34", "V35", "Cpp", "V37", "V47", "V48", "V49", "V50",
                                "V51", "V57", "V71", "V72", "V73", "V79", "V85", "V86", 
                                "V91")
        p <- p+1
    }
    # converting factors to numeric
    ff <- sapply(arranged, is.factor)
    for(cc in 1:dim(arranged)[2]){
        if(ff[cc] == T){
            arranged[, cc] <- as.numeric(levels(arranged[, cc]))[arranged[, cc]]}
    }
    write.table(arranged, file = name, sep = ",", quote = F, row.names = F)
}

# Standarizing the files (same financial variables)
checks <- data.frame()
for(i in 1:length(listFiles)){
    tmp<- read.csv(listFiles[i])
    checks <- rbind(checks, c(i, dim(tmp)[1], dim(tmp)[2]))
}
checks$X25L <- factor(checks$X25L)

# subsetting
f25 <- checks[checks$X25L == 25,] # antes f127
f26 <- checks[checks$X25L == 26,] # antes f262
f28 <- checks[checks$X25L == 28,] # antes f176

m <- 1
n <- 1
p <- 1
for(i in 1:length(listFiles)){
    input <- data.frame()
    name <- listFiles[i]
    tmp <- read.csv(listFiles[i])
    # 127
    if(i == f25[m, 1] && m<dim(f25)[1]+1){
        input <- cbind.data.frame(tmp$year, rep("Insurance", length(tmp$year)), tmp$V2, tmp$V3, tmp$V5, tmp$V7, tmp$V10, tmp$V19, 
                                     tmp$V26, tmp$V27, tmp$V34, tmp$V35, tmp$V38 + tmp$V39 + 
                                     tmp$V40, tmp$V37, tmp$V47, tmp$Cpp, tmp$V57, tmp$V71, 
                                     tmp$V72, tmp$V73, tmp$V79, tmp$V85, tmp$V86, tmp$V91)
        colnames(input) <- c("year", "Field", "V2", "V3", "V5", "V7", "V10", "V19", "V26", 
                                "V27", "V34", "V35", "Cppcp", "V37", "V47", 
                                "Cpplp", "V57", "V71", "V72", "V73", 
                                "V79", "V85", "V86", "V91")
        m <- m+1
    }
    # f176
    if(i == f28[n, 1] && n<dim(f28)[1]+1){
        input <- cbind.data.frame(tmp$year, rep("Manufacturing", length(tmp$year)), tmp$V2, tmp$V3, tmp$V5, tmp$V7, tmp$V10, tmp$V19, 
                                     tmp$V26, tmp$V27, tmp$V34, tmp$V35, tmp$V38 + tmp$V39 + 
                                     tmp$V40, tmp$V37, tmp$V47, tmp$V48 + tmp$V49 + tmp$V50 + 
                                     tmp$V51, tmp$V57, tmp$V71, tmp$V72, tmp$V73, tmp$V79, 
                                     tmp$V85, tmp$V86, tmp$V91)
        colnames(input) <- c("year", "Field", "V2", "V3", "V5", "V7", "V10", "V19", "V26", 
                                "V27", "V34", "V35", "Cppcp", "V37", "V47", 
                                "Cpplp", "V57", "V71", "V72", "V73", 
                                "V79", "V85", "V86", "V91")
        n <- n+1
    }
    # f262
    if(i == f26[p, 1] && p<dim(f26)[1]+1){
        input <- cbind.data.frame(tmp$year, rep("Banking", length(tmp$year)), tmp$V2, tmp$V3, tmp$V5, tmp$V7, tmp$V10, tmp$V19, 
                                     tmp$V26, tmp$V27, tmp$V34, tmp$V35, tmp$Cpp, tmp$V37, 
                                     tmp$V47, tmp$V48 + tmp$V49 + tmp$V50 + tmp$V51, tmp$V57, 
                                     tmp$V71, tmp$V72, tmp$V73, tmp$V79, tmp$V85, tmp$V86, 
                                     tmp$V91)
        colnames(input) <- c("year", "Field", "V2", "V3", "V5", "V7", "V10", "V19", "V26", 
                                "V27", "V34", "V35", "Cppcp", "V37", "V47", "Cpplp", 
                             "V57", "V71", "V72", "V73", "V79", "V85", "V86", 
                                "V91")
        p <- p+1
    }
    
    write.table(input, file = name, sep = ",", quote = F, row.names = F)
}

# computing the financial ratios
tmpfile <- list.files("rawData")
computeRatios <- function(ratios, tmp){
    # Ratios
    # Liquidity ratios
    QRA <- (tmp$V3 - tmp$V10)/tmp$V35 # quick ratio
    LRA <- tmp$V3/tmp$V35 # liquidity ratio
    CRA <- tmp$V5/tmp$V35 # cash ratio
    
    # Asset utilization or turnover ratios
    RTR <- tmp$V71/tmp$V7 # receivableTurnonverRatio
    ITR <- tmp$V72/tmp$V10 # inventoryTurnonverRatio
    NWR <- tmp$V71/(tmp$V3 - tmp$V35) # nwcTurnonverRatio
    ATR <- tmp$V71/tmp$V2 # assetTurnonverRatio
    ETR <- tmp$V71/tmp$V57 # equityTurnonverRatio
    FAT <- tmp$V71/tmp$V26 # fixedAssetTurnonverRatio
    LTA <- tmp$V71/tmp$V19 # longTermAssetTurnonverRatio
    CAT <- tmp$V71/tmp$V3 # currentAssetTurnonverRatio
    
    # Profitability ratios
    GPM <- tmp$V73/tmp$V71 # grossProfitMargin
    EBI <- tmp$V85/tmp$V71 # ebitMargin
    NPM <- tmp$V91/tmp$V71 # netProfitMargin ROS(returnOn Sales)
    REQ <- tmp$V91/tmp$V57 # returnOnEquity
    ROA <- tmp$V91/tmp$V2 # returnOnAssets
    
    # Asset structure ratios
    CAS <- tmp$V3/tmp$V2 # currentAssetToTotalAssetRatio
    ICU <- tmp$V10/tmp$V3 # inventoryToCurrentAssetRatio
    CEQ <- tmp$V5/tmp$V3 # cashEquivToCurrentAssetRatio
    LTE <- tmp$V19/tmp$V2 # longTermToAssetRatio
    
    # Solvency ratios
    STF <- tmp$Cppcp/tmp$V34 # shortTermFinanDebtToTotalDebt
    STD <- tmp$V35/tmp$V34 # shortTermDebtToTotalDebt
    ICR <- tmp$V85/abs(tmp$V86) # interestCoverageRatio
    DER <- tmp$V34/tmp$V57 # debtRatio
    LER <- tmp$V34/tmp$V2 # leverageRatio
    TFD <- (tmp$Cppcp + tmp$Cpplp)/tmp$V34 # totalFinanDebtToTotalDebt
    ratios <- cbind(QRA, LRA, CRA, RTR, ITR, NWR, ATR, ETR, FAT, LTA, CAT, GPM, EBI, NPM, 
              REQ, ROA, CAS, ICU, CEQ, LTE, STF, STD, ICR, DER, LER, TFD)
    ratios
}

for(i in 1:length(listFiles)){
    ratios <- data.frame()
    name <- tmpfile[i]
    tmp <- read.csv(listFiles[i])
    ratios <- computeRatios(ratios, tmp)
    ratios <- cbind(tmp$year, rep(i, length(tmp$year)), levels(tmp$Field), ratios)
    colnames(ratios) <- c("year", "id", "Field", "QRA", "LRA", "CRA", "RTR", "ITR", "NWR", "ATR", 
                          "ETR", "FAT", "LTA", "CAT", "GPM", "EBI", "NPM", "REQ", 
                          "ROA", "CAS", "ICU", "CEQ", "LTE", "STF", "STD", "ICR", "DER", "LER", "TFD")
    write.table(ratios, file = paste("cleanData/", name, sep = ""), sep = ",", quote = F, row.names = F)
}


