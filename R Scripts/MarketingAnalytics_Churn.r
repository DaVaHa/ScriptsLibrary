### DATACAMP - MARKETING ANALYTICS ###

## CUSTOMER CHURN - LOGISTIC REGRESSION ## (part 2)

# import packages
library(dplyr)
library(ggplot2)

# load data
churnData <- read.csv('C:\\Users\\daniel.vanhasselt.JBC\\Desktop\\R Scripts\\churn_data.csv')
head(churnData)

# variables used : @JBC?
str(churnData, give.attr = FALSE)

# histogram
ggplot(churnData, aes(x = returnCustomer)) +
  geom_histogram(stat = "count")

# logistic regression model
logit <- glm(formula = returnCustomer ~ . - X - ID - orderDate - title , family = binomial, churnData) # family = binomial !!
summary(logit)

# interpret coefficients - exponential transformation to odds ratios
# coeff > 1 increases odds of P(Y=1), coeff < 1 decreases odds of P(Y=1)
coefsExp <- coef(logit) %>% exp() %>% round(2)
coefsExp

# stepAIC() - automatic model selection based on (lowest) AIC value
# adds or removes variables one by one and returns model with lowest AIC value
library(MASS)
logitNew <- stepAIC(logit, trace = 0) # hide intermediate steps with trace = 0
summary(logitNew)

# Save the formula of the new model (it will be needed for the out-of-sample part) 
formulaLogit <- as.formula(summary(logitNew)$call)
formulaLogit

# in-sample fit and thresholding : evaluation of model fit
# 3 pseudo R-squared statistics : McFadden, Cox & Snell, Nagelkerke
# reasonable if > 0.2 ; good if > 0.4; very good if > 0.5
library(descr)
LogRegR2(logitNew)

# predict probabilities
library(SDMTools)
churnData$predNew <- predict(logitNew, type = "response", na.action = na.exclude) # exclude observations with missing values
churnData %>%  dplyr::select(returnCustomer, predNew) %>% tail()

# confusion matrix 
# TN FN
# FP TP
confMatrix <- confusion.matrix(churnData$returnCustomer, churnData$predNew, threshold = 0.5) # default threshold = 0.5
confMatrix

# accuracy - in-sample fit
accuracyNew <- sum(diag(confMatrix)) / sum(confMatrix)
accuracyNew

# calculate threshold for greatest payoff (!) (suppose marketing action for predicted churn customers)
# profit of True Positives (correctly predicted churn & valid action) vs cost of False Positives (falsely predicted & unnecessary cost)
payoffMatrix <- data.frame(threshold = seq(from = 0.1, to = 0.5, by = 0.1),
                           payoff = NA) # Prepare data frame with threshold values and empty payoff column

for(i in 1:length(payoffMatrix$threshold)) {
  # Calculate confusion matrix with varying threshold
  confMatrix <- confusion.matrix(churnData$returnCustomer,
                                 churnData$predNew, 
                                 threshold = payoffMatrix$threshold[i])
  # Calculate payoff and save it to the corresponding row
  payoffMatrix$payoff[i] <- confMatrix[2,2]*1000 + confMatrix[2,1]*(-250) # profit TP vs cost FP
}
payoffMatrix

# out-of-sample validation
# 1. divide dataset in training & test data
# 2. build model on training data
# 3. calculate measures on test data

# set.seed ensures reproducibility of random components
set.seed(534381)
# 1. generating random index for training and test set
churnData$isTrain <- rbinom(nrow(churnData), 1, 0.66) # 66% training data & 34% test data
train <- subset(churnData, churnData$isTrain == 1)
test <- subset(churnData, churnData$isTrain == 0)
# 2. modeling model on train data
logitTrain <- glm(formula = formulaLogit, family = binomial, data = train) # train 
# 3. prediction on test data
test$predNew <- predict(logitTrain, type = "response", newdata = test) # test
# confusion matrix & accuracy - out-of-sample
confMatrixTest <- confusion.matrix(test$returnCustomer, test$predNew, threshold = 0.3) # default threshold = 0.5
confMatrixTest
accuracyTest <- sum(diag(confMatrixTest)) / sum(confMatrixTest)
accuracyTest

# cross validation
# divides data in buckets (fe 6)
# measures are the average of (fe 6) models whereby each bucket is used once as test data
library(boot)
costAcc <- function(r, pi = 0) {
  cm <- confusion.matrix(r, pi, threshold = 0.3)
  acc <- sum(diag(cm)) / sum(cm)
  return(acc)
}
# accuracy - cross validation
set.seed(534381)
cv.glm(churnData, logitNew, cost = costAcc, K = 6)$delta[1] # data, logreg model, cost function, K folds



