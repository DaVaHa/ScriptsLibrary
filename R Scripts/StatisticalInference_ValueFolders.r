## STATISTICAL INFERENCE : VALUE OPTIN ?

# connectie
library(RODBC)
#con <- odbcConnect("Rstudioconnection") #Ik heb deze connectie gecreeerd zie word document (voordeel via windows connectie)
con <- odbcDriverConnect('driver={SQL Server};server=BIPROD;database=JBC_BI_Sandbox;trusted_connection=true') # werkt als je met VPN geconnecteerd bent

# query
query <- paste('SELECT * FROM CAR_PredictKids_Pivot;')
str(query)

# query uitvoeren
data <- sqlQuery(con, query)

# rename columns
#data <- data %>% rename(Kind = `Kind(7-14j)`)
#data <- data %>% rename(Peuter = `Peuter(2-7j)`)

# show output
str(data)
head(data,100)
summary(data)


### script ###

# Import packages
library(dplyr)
library(tidyverse)
library(corrplot)

# Show correlation matrix - only for numeric columns  => KIDS LEEFTIJD
data %>% dplyr :: select( names(dplyr::select_if(data, is.numeric)) )  %>% 
  cor() %>% corrplot()


# Show overview of missing data
#library(mice)
#md.pattern(data)

#library(VIM)
#aggr_plot <- aggr(data, 
#                  col=c('navyblue','red'), numbers=TRUE, sortVars=TRUE, labels=names(data),cex.axis=.7, gap=3,ylab=c("Histogram of missing data","Pattern"))


# Run regression model
# 6. Run Linear Regression
target_column <- 'TARGET_ZOMER'   # target column
columns_not_to_use <- c(
  'CUSTOMERID','TARGET_WINTER', 'OMZET_TARGET', 'Dames','Heren', 'MARGE', 'TARGET_ZOMER'
  # 'TNS19','Herfstfolder19','WinterSint19'
#  'Heren', 'Dames', 'Kind', 'MARGE', 
)

# Train linear regression model on training data
if (is.null(columns_not_to_use)){
  skip_columns <- ''
} else {
  skip_columns <- paste(columns_not_to_use, collapse='', seq=' - ')
} 
formula_linreg <- as.formula(paste(target_column, '~ . -', skip_columns, target_column))
print(formula_linreg)
linReg <- lm(formula_linreg, data = data)
summary(linReg)

# 5. Remove outliers
# Calculate Cook's distance & cutoff
cooksd <- cooks.distance(linReg)
outlier_cutoff <- 1
cutoff <- outlier_cutoff * mean(cooksd, na.rm=TRUE)

# Plot observations and cutoff line
#plot(cooksd, pch="*", cex=2, main="Influential Obs by Cook's distance")  # plot cook's distance
#abline(h = cutoff, col="red")  # cutoff line = 4 x mean


# Remove if Cook's distance > cutoff
data_outliers <- as.numeric(names(cooksd)[(cooksd > cutoff)])
data_excl_outliers <- data[-data_outliers, ]
str(data_excl_outliers)

# Rerun linear regression
linReg <- lm(formula_linreg, data = data_excl_outliers)
formula_linreg
summary(linReg)

git # Check distribution of residuals : according to Quantile-Quantile line ?
plot.new()
qqnorm(linReg$residuals)
qqline(linReg$residuals, col='red')

plot(linReg$fitted.values, linReg$residuals)
abline(h=0, col='red')

# shapiro.test(linReg$residuals) # only for sample size between 3 and 5000

# p value < 0.05 = significant coefficient (= coefficient significantly different from 0)
# F-test : test if R-squared is significantly different from 0 (= if model is useful or not) # p < 0.05 = useful model




# Variance Inflation Factor (VIF)
# VIF = 1 means not correlated ; VIF = 5 means highly correlated (& should be removed from predictors)
# Detects multicollinearity : how much the variance of coefficients is inflated because of correlation between predictors of the model
library(rms)
vif(linReg)





# => 27.85 euro ! 
# Analytisch bevestigen?





