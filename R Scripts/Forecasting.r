############################
##                        ##
##      FORECASTING       ##
##                        ##
############################

# install.packages("forecast")

library("forecast")
library("ggplot2")
library("fpp2")
library("readxl")

# Create "ts" (time series) object
mydata <- read_excel("exercise1.xlsx")
head(mydata)
myts <- ts(mydata[,2:4], start = c(1981, 1), frequency = 4)

# Plot the data with facetting
autoplot(myts, facets = TRUE)
autoplot(myts, facets = FALSE)

# Find the max (index) in the gold series
goldoutlier <- which.max(gold)
gold[which.max(gold)]

# Check the frequency of a time series
frequency(gold)

# Subset time series
beer <- window(ausbeer, start = 1992, end = NULL) # relevant time value
autoplot(beer)
beer <- subset(ausbeer, start = 80) # index value
autoplot(beer)

# Create plots of the time series data
autoplot(beer)
ggseasonplot(beer)
ggsubseriesplot(beer)
# Produce a polar coordinate season plot for the beer data
ggseasonplot(beer, polar = TRUE)
# Create a lag plot of the oil data
gglagplot(oil)

# The correlations associated with the lag plots form 
# what is called the autocorrelation function (ACF). 
ggAcf(oil)

# Create ACF of a differenced time series
ggAcf(diff(goog))

# White noise = time series that is purely random
# We can test for white noise by looking at an ACF plot or by doing a Ljung-box test
# A p-value > 0.05 suggests the data are not significantly different from white noise
set.seed(3) 		# reproducibility
wn <- ts(rnorm(36)) # white noise
autoplot(wn) 		# plot
ggAcf(wn) + ggtitle("Sample ACF for White Noise") 
# Expectation : each correlation is close to zero
# 95 % of all autocorrelations for white noise should lie within the blue lines 
# if not : series is probably not white noise

# Ljung-box test : considers the first "h" autocorrelation values together
# Null hypothesis : data = white noise (reject if p < 0.05)(not reject if p > 0.05)
# A significant test (small p-value) indicates the data are probably not white noise
Box.test(pigs, lag = 24, fitdf = 0, type ="Lj")
# Ljung-Box test of a differenced time series
Box.test(diff(goog), lag = 10, type = "Ljung")

# Naive forecast : use most recent observation (= useful benchmark)

# METHOD 1 : Use naive() to forecast non-seasonal time series like stock prices
fcgoog <- naive(goog, 20)
autoplot(fcgoog)
summary(fcgoog)

# METHOD 2 : Use snaive() to forecast seasonal time series like beer production
fcbeer <- snaive(ausbeer, 16)
autoplot(fcbeer)
summary(fcbeer)

# Residuals should look like white noise : prediction intervals are computed assuming :
# uncorrelated residuals, mean = zero, constant variance & normally distributed
# Check the residuals from (fe) naive forecast
goog %>% naive() %>% checkresiduals()

training <- window(oil, end = 2003)
test <- window(oil, start = 2004)
fc <- naive(training, h = 10)
autoplot(fc) + autolayer(test, series = "Test data")

# METHOD 3 : Forecast = mean of all observations
fc <- meanf(training, h = 10)
autoplot(fc) + autolayer(test, series = "Test data")

# Forecast error = difference between observed value and its forecast in the test set (!= residuals)
# residuals = errors on training set (vs test set) and based on one-step forecasts (vs multi-step)
# Compute accuracy using forecast errors on test data
accuracy(fc, test)
accuracy(fc, test)["Test set","MAPE"]
# Measures of forecast accuracy : the smaller the better!
# MAE = Mean Absolute Error
# MSE = Mean Squared Error
# RMSE = Root Mean Squared Error
# MAPE = Mean Absolute Percentage Error
# MASE = Mean Absolute Scaled Error

# Example : compare naive with mean forecasts
train <- subset(gold, end = 1000)
test <- subset(gold, start = 1001)
naive_fc <- naive(train, h = 108)
mean_fc <- meanf(train, h = 108)
accuracy(naive_fc, gold)
accuracy(mean_fc, gold)
autoplot(naive_fc) + autolayer(test, series = "Test data")
autoplot(mean_fc) + autolayer(test, series = "Test data")

# Cross validation
# Choose the model with the smallest MSE computed using time series cross-validation
# Compute it at the forecast horizon of most interest to you
tsCV

# Compute cross-validated errors for up to 8 steps ahead
e <- tsCV(goog, forecastfunction = naive, h = 8)
# Compute the MSE values and remove missing values
mse <- colMeans(e^2, na.rm = TRUE)
# Plot the MSE values against the forecast horizon
data.frame(h = 1:8, MSE = mse) %>%
  ggplot(aes(x = h, y = MSE)) + geom_point()

# METHOD 4 : Simple Exponential Smoothing (SES)
# = more recent observations get more weight
# works when data has no seasonality or trend
fc <- ses(marathon, h = 10)
summary(fc) # model parameters
autoplot(fc) + autolayer(fitted(fc)) # Plot forecasts incl for training data

# Compare two methods
train <- subset(marathon, end = length(marathon) - 20) # training set
fcses <- ses(train, h = 20) # SES forecast
fcnaive <- naive(train, h = 20) # Naive forecast
accuracy(fcses, marathon) # train & test accuracy
accuracy(fcnaive, marathon) # train & test accuracy

# METHOD 5 & 6 : Exponential smoothing with trend (Holt's method)
# "local linear" trend  = same trend for future forecasts
# "damped linear" trend = trend levels off to constant
fc1 <- holt(train, h = 20, PI = FALSE) # PI = prediction intervals
fc2 <- holt(train, damped = TRUE, h = 20, PI = FALSE)
autoplot(marathon) + xlab("Year") + ylab("Minutes") +
  autolayer(fc1, series="Linear trend") +
  autolayer(fc2, series="Damped trend")

# METHOD 7 & 8: Exponential smoothing with trend & seasonality (Holt-Winters)
# additive & multiplicative version
# seasonal component averages zero for additive version and 1 for multiplicative version
# if seasonality increases with the level of the series => multiplicative version
aust <- window(austourists, start = 2005)
fc1 <- hw(aust, seasonal = "additive") # default : damped = FALSE
fc2 <- hw(aust, seasonal = "multiplicative") # default : damped = FALSE
# forecasting methods with non-white noise residuals can still provide useful forecasts!
checkresiduals(fc1)
checkresiduals(fc2)


# METHOD 9 : ETS model = Errors, Trends, Seasonality  (= Automatic Best Model Selection)
# "innovations state space model"
# Error = Additive or Multiplicative (= noise increases with level of series)
# Trend = None, Additive, Damped
# Seasonality = None, Additive or Multiplicative (=seasonality increases with level of series)
# Maximum likelihood estimation to optimize parameters & way of generating prediction intervals
# Best model selection based on AICc (corrected Akaike's Information Criterion)
ets(ausair) # returns best model, but no forecasts
ausair %>% ets() %>% forecast() %>% autoplot()

train <- subset(ausair, end = length(ausair) - 5)
test <- subset(ausair, start = length(ausair) - 5)
fc <- train %>% ets() %>% forecast(h = 5)
accuracy(fc, ausair)
autoplot(fc) + autolayer(test, series = "Test data")

# Fit ETS model
fitaus <- ets(austa)
# Check residuals
checkresiduals(fitaus)
# Plot forecasts
autoplot(forecast(fitaus))

# Compare ETS vs Seasonal Naive with Cross Validation
# Function to return ETS forecasts
fets <- function(y, h) {
  forecast(ets(y), h = h)
}
# Apply tsCV() for both methods
e1 <- tsCV(gold, forecastfunction = fets, h = 4)
e2 <- tsCV(gold, forecastfunction = snaive, h = 4)
# Compute MSE of resulting errors (watch out for missing values)
mean(e1^2, na.rm = TRUE)
mean(e2^2, na.rm = TRUE)
# Take model with lowest forecast MSE
bestmse <- mean(e2^2, na.rm = TRUE)

train <- subset(ausbeer, end = length(ausbeer) - 8)
test <- subset(ausbeer, start = length(ausbeer) - 8)
e1 <- tsCV(train, forecastfunction = fets, h = 8)
e2 <- tsCV(train, forecastfunction = snaive, h = 8)
mean(e1^2, na.rm = TRUE)
mean(e2^2, na.rm = TRUE)
fc1 <- train %>% ets() %>% forecast(h = 8)
fc2 <- train %>% snaive() %>% forecast(h = 8)
autoplot(train) + autolayer(fc1)
accuracy(fc, ausbeer)


# Box-Cox transformation
# = to stabilize variation in time series as level of series increases
# Transformations : square root (x^0.5), cube root (x^0.3333), logarithm(log(x)), inverse (-1/x)
# BoxCox : log(x) when lambda = 0 & (x^lambda-1)/lambda when lambda != 0
# lambda = 1 : no substantive transformation
# lambda = 0.5 : square root plus linear transformation
# lambda = 1/3 : cube root plus linear tranformation
# lambda = 0 : natural logarithm transformation
# lambda = -1 : inverse transformation
# recommended to use : -1 <= lambda <= 1
# Not common to use BoxCox transformation for ETS model, as ETS can 
# handle increasing variance with multiplicative error & seasonal components directly
BoxCox.lambda(train)


# METHOD 10 : ARIMA
# AutoRegressive Integrated Moving Average models
# Automatic best model based on minimized AICc
# AICc only usable within same class of model (so not for comparison between ETS & ARIMA)
# Autoregressive (AR) = regression of time series with lagged observations as predictors
# Moving average (MA) = regression with lagged errors as predictors
# ARMA = AR + MA = lagged observations & errors as predictors
# => can only work with stationary data, so might need to difference data first
# I = Integrated = differenced d times to make series stationary => ARIMA(p,d,q)
# p = number of ordinary AR lags
# d = number of lag-1 differences
# q = number of ordinary MA lags
# drift = coefficient c
# auto.arima() : model will be fitted to the transformed data
# & forecasts will be back-transformed onto the original scale
fit <- auto.arima(usnetelec)
summary(fit)
# Model with chosen parameters
Arima(order= c(1,1,1), include.constant = TRUE)
# Example
austa %>% 
  Arima(order = c(0, 2, 1), include.constant = FALSE) %>% 
  forecast() %>% 
  autoplot()

# Don't use the default stepwise search : might find better model, but takes longer to run!
fit2 <- auto.arima(euretail, stepwise = FALSE)

# Compare ETS with ARIMA (1)
# Use time series cross-validation to compare ARIMA with ETS model
# Set up forecast functions for ETS and ARIMA models
fets <- function(x, h) {
  forecast(ets(x), h = h)
}
farima <- function(x, h) {
  forecast(auto.arima(x),h = h)
}
# Fit an ARIMA and an ETS model to the training data
train <- window(qcement, start = 1988, end = c(2007,4))
# Compute CV errors for ETS & ARIMA
e1 <- tsCV(train, forecastfunction = fets, h = 4)
e2 <- tsCV(train, forecastfunction = farima, h = 4)
# Find MSE of each model class
mean(e1^2, na.rm = TRUE)
mean(e2^2, na.rm = TRUE)

# Compare ETS with ARIMA (2)
fit1 <- ets(train)
fit2 <- auto.arima(train)
# Check that both models have white noise residuals
checkresiduals(fit1)
checkresiduals(fit2)
# Produce forecasts for each model
fc1 <- forecast(fit1, h = 8)
fc2 <- forecast(fit2, h = 8)
# Use accuracy() to find better model based on RMSE
accuracy(fc1, qcement)
accuracy(fc2, qcement)
# Plot 10-year forecasts using the best model class
qcement %>% farima(h=8) %>% autoplot()


# METHOD 11 : Dynamic regression : to include external variables
# Time plots of demand and temperatures
autoplot(elec[, c("Demand", "Temperature")], facets = TRUE)
# Matrix of regressors
xreg <- cbind(MaxTemp = elec[, "Temperature"], 
              MaxTempSq = elec[, "Temperature"]^2, 
              Workday = elec[,"Workday"]
)
# Fit model
fit <- auto.arima(elec[,"Demand"], xreg = xreg)
# Forecast fit one day ahead
forecast(fit, xreg = cbind(20, 400, 1))


# METHOD 12 : Dynamic harmonic regression : for weekly, daily or sub-daily data
# USing Fourier terms (sums of sin & cos)
# error term to be modeled as a non-seasonal ARIMA process
# assumes the seasonal pattern does not change over time! 
# (seasonal ARIMA does allow seasonal pattern to evolve over time)
fit <- auto.arima(cafe, xreg = fourier(cafe, K = 1), seasonal = FALSE, lambda = 0) # lambda = 0 is log transformation
fit %>% forecast(xreg = fourier(cafe, K = 1, h = 24)) %>% autoplot() + ylim(1.6, 5.1) # use same value for K !
# K decides the "wiggly"-ness of the seasonal pattern
# => try various values for K and select model with lowest AICc value!
# K can not be more than m/2 (= half the seasonal period)

# Set up harmonic regressors of order 13
harmonics <- fourier(gasoline, K = 13)
# Fit regression model with ARIMA errors
fit <- auto.arima(gasoline, xreg = harmonics, seasonal = FALSE) # seasonality is handled by regressors
# Forecasts next 3 years
newharmonics <- fourier(gasoline, K = 13, h = 156)
fc <- forecast(fit, xreg = newharmonics)
# Plot forecasts fc
autoplot(fc)


# METHOD 13 : TBATS

# TBATS model : like dynamic harmonic regression but seasonality is allowed to change over time
# Trigonometric terms for seasonality
# Box-Cox transformations for heterogeneity
# ARMA errors for short-term dynamics
# Trend (possibly damped)
# Seasonal (including multiple and non-integer periods)
# = very general and handles a large range of time series
# = useful for data with large seasonal periods, and multiple seasonal periods
# entirely automated, but slow for long time series & often too wide prediction intervals
gasoline %>% tbats() %>% forecast() %>% autoplot() + xlab("Year") + ylab("thousand barrels per day")

# TBATS( Box-Cox transformation parameter, ARMA error, Damping parameter, <Seasonal period,Fourier terms>)

# Plot the gas data
autoplot(gas)
# Fit a TBATS model to the gas data
fit <- tbats(gas)
# Forecast the series for the next 5 years
fc <- forecast(fit, h = 60)
# Plot the forecasts
autoplot(fc)
# Record the Box-Cox parameter and the order of the Fourier terms
lambda <- 0.082
K <- 5


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


# Out-of-sample one-step forecasts
#https://robjhyndman.com/hyndsight/out-of-sample-one-step-forecasts/

# ARIMA : one-step forecast
arima_model <- auto.arima(train)
summary(arima_model)
fit_arima <- Arima(test, model = arima_model)
#summary(fit_arima)
accuracy(fit_arima)
fc_arima <- fitted(fit_arima)
autoplot(train) + autolayer(test, series = "Test") + autolayer(fc_arima, series = "Forecast")
accuracy(fc_arima, test)








