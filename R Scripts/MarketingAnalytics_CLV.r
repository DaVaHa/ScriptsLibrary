### DATACAMP - MARKETING ANALYTICS ###

## CUSTOMER LIFETIME VALUE - LINEAR REGRESSION ## (part 1)

# import packages
library(dplyr)
library(ggplot2)

# load data
clvData1 <- read.csv('C:\\Users\\daniel.vanhasselt.JBC\\Desktop\\R Scripts\\clvData1.csv')
clvData2 <- read.csv('C:\\Users\\daniel.vanhasselt.JBC\\Desktop\\R Scripts\\clvData2.csv')
head(clvData1)

# variables used : @JBC?
str(clvData1, give.attr = FALSE)
# nOrders, nItems, daysSinceLastOrder, margin, returnRatio, shareOwnBrand, shareVoucher,
# shareSale, gender, age, marginPerOrder, itemsPerOrder, futureMargin
# other : customerDuration, ticketValue, itemPrice, onlineSales, distanceStore, paymentMethod, newsletter, homeDelivery

# Correlation matrix
library(corrplot)
clvData1 %>%  dplyr::select(nOrders, nItems, daysSinceLastOrder, margin, returnRatio, shareOwnBrand, 
                            shareVoucher, shareSale, age, marginPerOrder, itemsPerOrder, futureMargin) %>% 
        cor() %>% corrplot()

# plotting variables
ggplot(clvData1, aes(margin, futureMargin)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) + 
  xlab("Margin year 1") + 
  ylab("Margin year 2")

# multiple linear regression model 
multipleLM <- lm(futureMargin ~ margin + nOrders + nItems + daysSinceLastOrder +
                   returnRatio + shareOwnBrand + shareVoucher + shareSale + 
                   gender + age + marginPerOrder + marginPerItem + 
                   itemsPerOrder, data = clvData1)
summary(multipleLM)

# multicollinearity (= problem of correlated explanatory variables)
# Variance Inflation Factors (= increase in variance of coefficients due to multicollinearity)
library(rms)
vif(multipleLM)

# VIF above 5 is problematic, above 10 is horrible 
# => remove one with highest VIF of each pair (see corrplot) from model !! (so all VIF's are below 10 and preferably below 5)
multipleLM2 <- lm(futureMargin ~ margin + nOrders + 
                    daysSinceLastOrder + returnRatio + shareOwnBrand + 
                    shareVoucher + shareSale + gender + age + 
                    marginPerItem + itemsPerOrder, 
                  data = clvData1)
vif(multipleLM2)

# Interpret new model
summary(multipleLM2)

# p values of coefficientsAI
# p value < 0.05 = significant ( = coefficient is significantly different from 0)

# F-test
# test if R-squared is significantly different from 0 # test if model is useful or not
# p value < 0.05 = useful model

# AIC value to avoid overfitting
# take model with smallest AIC value, if comparing models
AIC(multipleLM2)

# stepAIC() from MASS package
# automatic model selection based on (lowest) AIC value
# adds or removes variables one by one and returns (reduced) model with lowest AIC value
library(MASS)
linregAuto <- stepAIC(multipleLM2, trace = 0) # hide intermediate steps with trace = 0
AIC(linregAuto)
summary(linregAuto)

# Predict future values
predSales <- predict(linregAuto, newdata = clvData2)

# out-of-sample validation - to avoid overfitting
# 1. divide dataset in training & test data
# 2. build model on training data
# 3. calculate measures on test data

# set.seed ensures reproducibility of random components
set.seed(534381)
# 1. generating random index for training and test set
clvData1$isTrain <- rbinom(nrow(clvData1), 1, 0.66) # 66% training data & 34% test data
train <- subset(clvData1, clvData1$isTrain == 1)
test <- subset(clvData1, clvData1$isTrain == 0)
# 2. modeling on train data
linregTrain <- lm(futureMargin ~ margin + nOrders + 
                    daysSinceLastOrder + returnRatio + shareOwnBrand + 
                    shareVoucher + shareSale + gender + age + 
                    marginPerItem + itemsPerOrder, 
                  data = train) # train
# 3. prediction on test data
test$predNew <- predict(linregTrain, newdata = test) # test
# out-of-sample measures for linear regression 
# RMSE for test predictions?
# ?

# cross-validation - to avoid overfitting
library(DAAG)
cv.lm(clvData1, linregAuto, m=3, dots = FALSE, seed=29, plotit=FALSE, printit=TRUE)








