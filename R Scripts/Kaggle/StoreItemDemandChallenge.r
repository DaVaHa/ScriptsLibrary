# Store Item Demand Challenge # 

# https://www.kaggle.com/c/demand-forecasting-kernels-only/overview/evaluation ## 
# 5 years of store-item sales data
# asked to predict 3 months of sales for 50 different items at 10 different stores.
# evaluated on SMAPE between forecasts and actual values. We define SMAPE = 0 when the actual and predicted values are both 0.
# Submission fil : id,sales 0,35

# 10 stores, 50 product (per product, 10 stores & then next product and so on)
# Needed : prediction for 3 months (n = 90)

# Daily data : STL, Dynamic Harmonic Regression or TBATS
# https://otexts.com/fpp2/weekly.html
# Too high frequency for ETS


library("xts")
library("forecast")
library("ggplot2")
library("readxl")
library("forecastHybrid")
library("dplyr")

## DATA ##

path_to_dir <- "C:\\Users\\daniel.vanhasselt.JBC\\Desktop\\Kaggle\\Competitions\\StoreItemDemandChallenge\\"
sample <- read.csv(paste(path_to_dir, "sample_submission.csv", sep=""))
head(sample)

train <- read.csv(paste(path_to_dir, "train.csv", sep=""))
head(train)
tail(train)
unique(data.frame(train$store, train$item))
test <- read.csv(paste(path_to_dir, "test.csv", sep=""))
head(test)

## EVALUATION ##

# sMAPE : Symmetrical Mean Absolute Percentage Error
# https://otexts.com/fpp3/accuracy.html
abs_diff <- function(x,y){
  200*abs(x - y)/(abs(x)+abs(y))
}
smape <- function(x,y) {
  df <- data.frame(x,y)
  #df <- df[x != 0 | y != 0,]
  df$smape <- abs_diff(df$x, df$y)
  df$smape[is.na(df$smape)] = 0
  mean(df$smape)
}
x <- as.vector(c(1,2,4,0,1,0))
y <- as.vector(c(1,3,4,0,1,0))
smape(x,y)

## TEST : forecast methods on one product & one store ##

# filter product & store 
product <- train %>% filter((train$store == 1) & (train$item == 1))
unique(product$store)
unique(product$item)
myts <- ts(data = product$sales, start = c(2013,1,1), end = c(2017,12,31), frequency = 365)
autoplot(myts)

# Split data into train & test
pr_train <- subset(myts, end = length(myts)-180) 
pr_test <- subset(myts, start = length(myts)-180+1, end=length(myts)) 
autoplot(pr_train, series="Train") + autolayer(pr_test, series="Test")

# TBATS
fc_tbats <- pr_train %>% tbats() %>% forecast(h=180)
autoplot(fc_tbats) + autolayer(pr_test, series = "Test") + autolayer(fitted(fc_tbats), series='Fitted')
accuracy(fc_tbats, pr_test)
smape(fc_tbats$mean, pr_test)
# 20.33436

# Dynamic Harmonic Regression
# => try various values for K and select model with lowest AICc value!
# K can not be more than m/2 (= half the seasonal period)
harmonics <- fourier(pr_train, K = 10)
fit_harmonic <- auto.arima(pr_train, xreg = harmonics, seasonal = FALSE)
newharmonics <- fourier(pr_train, K = 10, h = 180)
fc_harmonic <- forecast(fit_harmonic, xreg = newharmonics)
summary(fc_harmonic) #data
#checkresiduals(fc_harmonic) 
# K = 1  : AICc=7893.09  
# K = 2  : AICc=7895.2   
# K = 3  : AICc=7833.5
# K = 4  : AICc=7875.91   
# K = 5  : AICc=7818.87   
# K = 7  : AICc=7844.58   
# K = 8  : AICc=7804.96   
# K = 9  : AICc=7799.96   
# K = 10 : AICc=7796.81  # lowest AICc    
# K = 11 : AICc=7884.69   
# K = 12 : AICc=7888.26    
# K = 20 : AICc=7827.61  
# K = 30 : AICc=7845.67     
autoplot(fc_harmonic) + autolayer(pr_test, series = "Test") + autolayer(fitted(fc_harmonic), series='Fitted') #plot
accuracy(fc_harmonic, pr_test)
smape(fc_harmonic$mean, pr_test)
# 20.8043

# Combo : TBATS & STLM
model_ts <- hybridModel(pr_train, weights="equal", models="ts")
model_ts$weights
fc_combo_ts <- forecast(model_ts, h = 180)
autoplot(fc_combo_ts) + autolayer(pr_test, series = "Test") + autolayer(fitted(fc_combo_ts), series='Fitted') #plot
accuracy(fc_combo_ts, pr_test)
smape(fc_combo_ts$mean, pr_test)
# 20.81416

# ARIMA : one-step forecast
arima_model <- auto.arima(pr_train)
summary(arima_model)
fit_arima <- Arima(pr_test, model = arima_model)
#summary(fit_arima)
accuracy(fit_arima)
fc_arima <- fitted(fit_arima)
autoplot(pr_train) + autolayer(pr_test, series = "Test") + autolayer(fc_arima, series = "Forecast")
accuracy(fc_arima, pr_test)
smape(fc_arima, pr_test)
# 20.95947

# STL
fc_stl <- stlf(pr_train, h = 180)
autoplot(fc_stl) + autolayer(pr_test, series = "Test") + autolayer(fitted(fc_stl), series='Fitted')
#summary(fc_stl) 
#accuracy(fc_stl)
#checkresiduals(fc_stl)
accuracy(fc_stl, pr_test) 
smape(fc_stl$mean, pr_test) 
# 22.25554

# Theta
fc_theta <- pr_train %>% thetaf() %>% forecast(h=180)
autoplot(fc_theta) + autolayer(pr_test, series = "Test") + autolayer(fitted(fc_theta), series='Fitted')
accuracy(fc_theta, pr_test) #accuracy - Theta 
smape(fc_theta$mean, pr_test)
# 23.04025

# Hybrid
fullCombo <- hybridModel(pr_train, weights="equal")
fullCombo$weights
fc_full_combo <- forecast(fullCombo, h = 180)
autoplot(fc_full_combo) + autolayer(pr_test, series = "Test") + autolayer(fitted(fc_full_combo), series='Fitted')
accuracy(fullCombo, pr_test, individual = TRUE)
accuracy(fc_full_combo, pr_test)
smape(fc_full_combo$mean, pr_test)
# 24.34421

# Seasonal Naive
fc_snaive <- snaive(pr_train, h = 180)
autoplot(fc_snaive) + autolayer(pr_test, series = "Test") + autolayer(fitted(fc_snaive), series='Fitted')
#summary(fc_snaive) 
#accuracy(fc_snaive)
#checkresiduals(fc_snaive)
accuracy(fc_snaive, pr_test) 
smape(fc_snaive$mean, pr_test) 
# 28.80907

# Neural network - feed forward with single hidden layer and lagged inputs

# Tried : one-step forecast
# Error in nnetar(pr_test, model = nn_model) : Series must be at least of length 366 to use fitted model
# nn_train <- subset(myts, end = length(myts)-366)
# nn_test <- subset(myts, start = length(myts)-366+1, end=length(myts)) 
# autoplot(nn_train, series="Train") + autolayer(nn_test, series="Test")
# nn_model <- nnetar(nn_train) 
# #summary(nn_model)
# accuracy(nn_model)
# fit_nn <- nnetar(nn_test, model = nn_model)
# accuracy(fit_nn)
# fc_nn <- fitted(fit_nn)
# autoplot(nn_train) + autolayer(nn_test, series = "Test") + autolayer(fc_nn, series = "Forecast")
# accuracy(fc_nn, nn_test)
# smape(fc_nn, nn_test)
# # ? not correct

nn_model <- nnetar(pr_train) 
accuracy(nn_model)
fc_nn <- forecast(nn_model, h = 180)
autoplot(pr_train) + autolayer(pr_test, series = "Test") + autolayer(fc_nn, series = "Forecast")
accuracy(fc_nn, pr_test)
smape(fc_nn$mean, pr_test)
# 34.77485



