### CHURN PREDICTION - JBC ###

# Doel = uitsparen folders van klanten die toch terugkomen.


## LOGISTIC REGRESSION ##

# import packages
library(dplyr)
library(ggplot2)
library(tidyverse)

# load data
churnData <- read.csv('C:\\Users\\daniel.vanhasselt.JBC\\Desktop\\DataLogReg.csv')
head(churnData)
summary(churnData)

# variables used : @JBC?
str(churnData, give.attr = FALSE)

# histogram
ggplot(churnData, aes(x = TARGET)) +
  geom_histogram(stat = "count")

# rename column name
names(churnData)[names(churnData) == "ï..CUSTOMER_WID"] <- "CUSTOMER_WID"

# change data type from Factor to Int
churnData$DAYS_SINCE_FIRST <- as.numeric(as.character(churnData$DAYS_SINCE_FIRST))

# remove rows with OMZET > 1000
churnData <- subset(churnData, OMZET < 500)

# remove NA rows
churnData <- churnData %>% drop_na()

# data too big ... sample
data <- sample_n(churnData, 300000)
ggplot(data, aes(x = TARGET)) +
  geom_histogram(stat = "count")

str(data)
# remove first data set
#remove(churnData)

# Correlation matrix
library(corrplot)
coefdata <- data
coefdata$CUSTOMER_WID <- NULL
coefdata$TARGET_OMZET <- NULL
coefdata$TARGET <- NULL
str(coefdata)
coefdata %>% cor() %>% corrplot()

# logistic regression model
logit <- glm(formula = TARGET ~ . - CUSTOMER_WID - TARGET_OMZET, family = binomial, churnData) # family = binomial !!
summary(logit)
# AIC: 1547353

# interpret coefficients - exponential transformation to odds ratios
# coeff > 1 increases odds of P(Y=1), coeff < 1 decreases odds of P(Y=1)
coefsExp <- coef(logit) %>% exp() %>% round(4)
coefsExp

# stepAIC() - automatic model selection based on (lowest) AIC value
# adds or removes variables one by one and returns model with lowest AIC value
library(MASS)
logitNew <- stepAIC(logit, trace = 0) # hide intermediate steps with trace = 0
summary(logitNew)
# AIC: 1547343

# Save the formula of the new model (it will be needed for the out-of-sample part) 
formulaLogit <- as.formula(summary(logitNew)$call)
formulaLogit

# coefficient stepAIC model
# coeff > 1 increases odds of P(Y=1), coeff < 1 decreases odds of P(Y=1)
coefsExp <- coef(logitNew) %>% exp() %>% round(4)
coefsExp

"
## new model ##

logitV2 <- glm(formula = TARGET ~ STUKS + MARGE + PRIJS + TICKET + DAGEN + ONLINE + VLA + RETOUR + P_BABY + P_HEREN + P_DAMES + P_KIND7.14 + P_KIND2.7 + T_P2Y_ZZ + T_P2Y_WW + T_PY_ZZ + T_PY_WW + T_SOLDEN + UITVERKOOP_VISIT + CLOSED_STORE_VISIT
                 , family = binomial, churnData) # family = binomial !!
summary(logitV2)
# AIC: 43232602
coef(logitV2) %>% exp() %>% round(4)

logitNewV2 <- stepAIC(logitV2, trace = 0) # hide intermediate steps with trace = 0
summary(logitNewV2)
# AIC : ?
"

# next steps : confusion matrix & predict & determine cut-off based on cost
predData <- read.csv('C:\\Users\\daniel.vanhasselt.JBC\\Desktop\\DataLogRegPredictFY19.csv')
head(predData)
str(predData)
# rename column name
names(predData)[names(predData) == "ï..CUSTOMER_WID"] <- "CUSTOMER_WID"
# change data type from Factor to Int
predData$DAYS_SINCE_FIRST <- as.numeric(as.character(predData$DAYS_SINCE_FIRST))
# remove NA rows
predData <- predData %>% drop_na()

# prediction on test data
predData$predNew <- predict(logitNew, type = "response", newdata = predData)
predData$predNew %>% tail(20)

# vizualize
viz_data <- sample_n(predData, 250000)
ggplot(viz_data, aes(x = predNew)) +
  geom_histogram(binwidth=0.05)

# export data
exportData <- predData %>%  dplyr::select(CUSTOMER_WID, OMZET, predNew)
write.csv(exportData,"C:\\Users\\daniel.vanhasselt.JBC\\Desktop\\ChurnPredictieFY19.csv", row.names = FALSE)

# in-sample fit and thresholding : evaluation of model fit
# 3 pseudo R-squared statistics : McFadden, Cox & Snell, Nagelkerke
# reasonable if > 0.2 ; good if > 0.4; very good if > 0.5
library(descr)
LogRegR2(logitNew)

# predict probabilities
library(SDMTools)
churnData$predNew <- predict(logitNew, type = "response", na.action = na.exclude) # exclude observations with missing values
churnData %>%  dplyr::select(TARGET, predNew) %>% tail(20)

# confusion matrix 
# TN FN
# FP TP
confMatrix <- confusion.matrix(churnData$TARGET, churnData$predNew, threshold = 0.5) # default threshold = 0.5
confMatrix

# accuracy - in-sample fit
accuracyNew <- sum(diag(confMatrix)) / sum(confMatrix)
accuracyNew

# calculate threshold for greatest payoff (!) (suppose marketing action for predicted churn customers)
# profit of True Positives (correctly predicted churn & valid action) vs cost of False Positives (falsely predicted & unnecessary cost)
payoffMatrix <- data.frame(threshold = seq(from = 0.1, to = 0.9, by = 0.05),
                           payoff = NA) # Prepare data frame with threshold values and empty payoff column

for(i in 1:length(payoffMatrix$threshold)) {
  # Calculate confusion matrix with varying threshold
  confMatrix <- confusion.matrix(churnData$TARGET,
                                 churnData$predNew, 
                                 threshold = payoffMatrix$threshold[i])
  # Calculate payoff and save it to the corresponding row
  # Doel = uitsparen folders van klanten die toch terugkomen.
  # profit TP : klanten komen toch terug, dus folders uitgespaard (8 x 0.5 euro)
  # cost FP : klanten komen niet terug, ondanks voorspeld ( 50 euro x 40% marge = 20 euro - 3 euro "uitgespaarde" folders)
  payoffMatrix$payoff[i] <- confMatrix[2,2]*1 + confMatrix[2,1]*(-1) # TARGET = gekocht! CHURN = pred(0)
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
cv.glm(data, logit, cost = costAcc, K = 6)$delta[1] # data, logreg model, cost function, K folds



