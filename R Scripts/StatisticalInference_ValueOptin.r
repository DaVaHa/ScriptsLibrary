## STATISTICAL INFERENCE : VALUE OPTIN ?

# connectie
library(RODBC)
#con <- odbcConnect("Rstudioconnection") #Ik heb deze connectie gecreeerd zie word document (voordeel via windows connectie)
con <- odbcDriverConnect('driver={SQL Server};server=BIPROD;database=JBC_BI_Sandbox;trusted_connection=true') # werkt als je met VPN geconnecteerd bent

# query
query <- paste('SELECT * FROM CAR_Optin;')
str(query)

# query uitvoeren
data <- sqlQuery(con, query)

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
library(mice)
md.pattern(data)

library(VIM)
aggr_plot <- aggr(data, 
                  col=c('navyblue','red'), 
                  numbers=TRUE, 
                  sortVars=TRUE, 
                  labels=names(data), 
                  cex.axis=.7, gap=3, 
                  ylab=c("Histogram of missing data","Pattern"))


# Run regression model
# 6. Run Linear Regression
target_column <- 'OMZET_TARGET'   # target column
columns_not_to_use <- c(
  'CUSTOMERID','LFTD','LFTD_ABS_34', 'OPTIN_NOOIT','KIDS_LFTD'
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
outlier_cutoff <- 4
cutoff <- outlier_cutoff * mean(cooksd, na.rm=TRUE)

# Plot observations and cutoff line
plot(cooksd, pch="*", cex=2, main="Influential Obs by Cook's distance")  # plot cook's distance
abline(h = cutoff, col="red")  # cutoff line = 4 x mean


# Remove if Cook's distance > cutoff
data_outliers <- as.numeric(names(cooksd)[(cooksd > cutoff)])
data_excl_outliers <- data[-data_outliers, ]

# Rerun linear regression
linReg <- lm(formula_linreg, data = data_excl_outliers)
summary(linReg)

# p value < 0.05 = significant coefficient (= coefficient significantly different from 0)
# F-test : test if R-squared is significantly different from 0 (= if model is useful or not) # p < 0.05 = useful model

# polynomial regression ?
# I(OMZET^2) +I(ONLINE^2) + I(VLA^2) + I(Baby^2) + I('Peuter(2-7j)'^2) +I('Kind(7-14j)'^2) + I(Dames^2) + I(Heren^2) + I(KIDS_MIN_AGE^2)
formula_polyreg <- as.formula(paste(target_column, '~ . + I(OMZET^2) +I(ONLINE^2) + I(VLA^2) + I(Baby^2) + I(Dames^2) + I(Heren^2) + I(KIDS_MIN_AGE^2) -', skip_columns, target_column))
polyReg <- lm(formula_polyreg, data = data_excl_outliers)
summary(polyReg)




# Variance Inflation Factor (VIF)
# VIF = 1 means not correlated ; VIF = 5 means highly correlated (& should be removed from predictors)
# Detects multicollinearity : how much the variance of coefficients is inflated because of correlation between predictors of the model
library(rms)
vif(linReg)




### LOOP OVER RANDOM % #### 
# => GEMIDDELDE & VERDELING ??

optin_values <- c()

for (i in 1:10000) {
  random_sample <- sample_frac(data_excl_outliers, 0.10)
  sample_linreg <- lm(formula_linreg, data = random_sample)
  #print(summary(sample_linreg))
  coefficient <- summary(sample_linreg)$coefficients[14,1]
  optin_values <- append(optin_values, coefficient)
}

# number of optin values:
print(paste("Nr of values ", length(optin_values)))
print(head(optin_values))
print(tail(optin_values))

# Plot distribution
hist(optin_values)

# Calculate mean optin value !!
print(paste("The value of an optin is :", mean(optin_values)))




# => 27.85 euro ! 
# Analytisch bevestigen?





