############################
##                        ##
##      FORECASTING       ##
##                        ##
############################

library("forecast")
library("ggplot2")
library("fpp2")
library("readxl")

# Create time series object
path_to_data <- "U:\\MIT\\Python\\OnlineSalesMonthly.xlsx"
data <- read_excel(path_to_data)
head(data)
str(data)
myts <- ts(data$OMZET, start = c(2016, 1), frequency = 12)
frequency(myts)
str(myts)
summary(myts)
myts

# Plot time series
autoplot(myts)
ggseasonplot(myts)
ggsubseriesplot(myts)
ggseasonplot(myts, polar = TRUE)
gglagplot(myts)

# Autocorrelation function (ACF). 
# = correlations associated with the lag plots form 
ggAcf(myts)
ggAcf(diff(myts))

# Ljung-box test
# Null hypothesis : data = white noise (reject if p < 0.05 & not reject if p > 0.05)
Box.test(myts, lag = 1, fitdf = 0, type ="Lj")
Box.test(myts, lag = 3, fitdf = 0, type ="Lj")
Box.test(myts, lag = 6, fitdf = 0, type ="Lj")
Box.test(myts, lag = 12, fitdf = 0, type ="Lj")
Box.test(diff(myts), lag = 12, type = "Ljung")

# Split data into train & test
train <- subset(myts, end = length(myts)-6-1) 
test <- subset(myts, start = length(myts)-6, end=length(myts)-1) 
autoplot(train, series="Train") + autolayer(test, series="Test")


# Forecast error = difference between observed value and its forecast in the test set (!= residuals)
# residuals = errors on training set (vs test set) and based on one-step forecasts (vs multi-step)
# Compute accuracy using forecast errors on test data
accuracy(fc, test)["Test set","MAPE"]
# Measures of forecast accuracy : the smaller the better!
# MAE = Mean Absolute Error
# MSE = Mean Squared Error
# RMSE = Root Mean Squared Error
# MAPE = Mean Absolute Percentage Error
# MASE = Mean Absolute Scaled Error


# METHOD 1 & 2 : Naive forecasts = use most (seasonally) recent observation

fc_naive <- naive(train, 6) #forecast
autoplot(fc_naive) + autolayer(test, series = "Test") + autolayer(fitted(fc_naive), series='Fitted') #plot
summary(fc_naive) #data
train %>% naive() %>% checkresiduals() #residuals = white noise (within blue lines) ?
accuracy(fc_naive, test) #accuracy - Naive

fc_snaive <- snaive(train, 6) #forecast
autoplot(fc_snaive) + autolayer(test, series = "Test") + autolayer(fitted(fc_snaive), series='Fitted') #plot
summary(fc_snaive) #data
checkresiduals(fc_snaive) #residuals = white noise (within blue lines) ?
accuracy(fc_snaive, test) #accuracy - Seasonal Naive

# METHOD 3 : Forecast = mean of all observations

fc_mean <- meanf(train, h = 6) #forecast
autoplot(fc_mean) + autolayer(test, series = "Test") + autolayer(fitted(fc_mean), series='Fitted') #plot
summary(fc_mean) #data
train %>% meanf() %>% checkresiduals() #residuals = white noise (within blue lines) ?
accuracy(fc_mean, test) #accuracy - Mean

# Cross validation - MSE
e <- tsCV(train, forecastfunction = naive, h = 6) # Calculate errors
mse <- colMeans(e^2, na.rm = TRUE) # Compute the MSE values (remove missing values)
data.frame(h = 1:6, MSE = mse) %>% ggplot(aes(x = h, y = MSE)) + geom_point() # Plot MSE vs forecast horizon

e2 <- tsCV(train, forecastfunction = meanf, h = 6) # Calculate errors
mse2 <- colMeans(e2^2, na.rm = TRUE) # Compute the MSE values (remove missing values)
data.frame(h = 1:6, MSE = mse2) %>% ggplot(aes(x = h, y = MSE)) + geom_point() # Plot MSE vs forecast horizon


# METHOD 4 : Simple Exponential Smoothing (SES) = more recent observations get more weight

fc_ses <- ses(train, h = 6)
autoplot(fc_ses) + autolayer(test, series = "Test") + autolayer(fitted(fc_ses), series='Fitted') #plot
summary(fc_ses) #data
train %>% ses() %>% checkresiduals() #residuals = white noise (within blue lines) ?
accuracy(fc_ses, test) #accuracy - SES

# METHOD 5 & 6 : Exponential smoothing with trend (Holt's method)

# "local linear" trend  = same trend for future forecasts
# "damped linear" trend = trend levels off to constant
fc_holt <- holt(train, h = 6, PI = FALSE) # PI = prediction intervals
autoplot(fc_holt) + autolayer(test, series = "Test") + autolayer(fitted(fc_holt), series='Fitted') #plot
summary(fc_holt) #data
train %>% holt() %>% checkresiduals() #residuals = white noise (within blue lines) ?
accuracy(fc_holt, test) #accuracy - Holt (local linear)

fc_holt_damped <- holt(train, damped = TRUE, h = 6, PI = FALSE) # PI = prediction intervals
autoplot(fc_holt_damped) + autolayer(test, series = "Test") + autolayer(fitted(fc_holt_damped), series='Fitted') #plot
summary(fc_holt_damped) #data
checkresiduals(fc_holt_damped) #residuals = white noise (within blue lines) ?
accuracy(fc_holt_damped, test) #accuracy - Holt (damped linear)

autoplot(train) + autolayer(test, series="Test") + 
  autolayer(fc_holt, series="Linear trend") + 
  autolayer(fc_holt_damped, series="Damped trend")

# METHOD 7 & 8: Exponential smoothing with trend & seasonality (Holt-Winters)

# additive & multiplicative version
# seasonal component averages zero for additive version and 1 for multiplicative version
# if seasonality increases with the level of the series => multiplicative version
fc_hw_add <- hw(train, h = 6, seasonal = "additive") # default : damped = FALSE
autoplot(fc_hw_add) + autolayer(test, series = "Test") + autolayer(fitted(fc_hw_add), series='Fitted') #plot
summary(fc_hw_add) #data
checkresiduals(fc_hw_add) #residuals = white noise (within blue lines) ?
accuracy(fc_hw_add, test) #accuracy - Holt-Winters (additive)

fc_hw_add_d <- hw(train, h = 6, seasonal = "additive", damped=TRUE)
autoplot(fc_hw_add_d) + autolayer(test, series = "Test") + autolayer(fitted(fc_hw_add_d), series='Fitted') #plot
summary(fc_hw_add_d) #data
checkresiduals(fc_hw_add_d) #residuals = white noise (within blue lines) ?
accuracy(fc_hw_add_d, test) #accuracy - Holt-Winters (additive & damped)

fc_hw_mul <- hw(train, h = 6, seasonal = "multiplicative") # default : damped = FALSE
autoplot(fc_hw_mul) + autolayer(test, series = "Test") + autolayer(fitted(fc_hw_mul), series='Fitted') #plot
summary(fc_hw_mul) #data
checkresiduals(fc_hw_mul) #residuals = white noise (within blue lines) ?
accuracy(fc_hw_mul, test) #accuracy - Holt-Winters (multiplicative)

fc_hw_mul_d <- hw(train, h = 6, seasonal = "multiplicative", damped=TRUE)
autoplot(fc_hw_mul_d) + autolayer(test, series = "Test") + autolayer(fitted(fc_hw_mul_d), series='Fitted') #plot
summary(fc_hw_mul_d) #data
checkresiduals(fc_hw_mul_d) #residuals = white noise (within blue lines) ?
accuracy(fc_hw_mul_d, test) #accuracy - Holt-Winters (multiplicative & damped)


# METHOD 9 : ETS model = Errors, Trends, Seasonality  (= Automatic Best Model Selection)

# "innovations state space model"
# Error = Additive or Multiplicative (= noise increases with level of series)
# Trend = None, Additive, Damped
# Seasonality = None, Additive or Multiplicative (= seasonality increases with level of series)
# Best model selection based on AICc (corrected Akaike's Information Criterion)
# Prone to overfitting ! Check forecast errors on test data !
ets(train) # returns best model, but no forecasts

fc_ets <- train %>% ets() %>% forecast(h=6) # forecast
autoplot(fc_ets) + autolayer(test, series = "Test") + autolayer(fitted(fc_ets), series='Fitted') #plot
summary(fc_ets) #data
checkresiduals(fc_ets) #residuals = white noise (within blue lines) ?
accuracy(fc_ets, test) #accuracy - ETS (Error,Trend,Seasonal)


# METHOD 10 : ARIMA

farima <- function(x, h) {
  forecast(auto.arima(x), h = h, stepwise = FALSE)
}
fc_arima <- farima(train, h = 6)
autoplot(fc_arima) + autolayer(test, series = "Test") + autolayer(fitted(fc_arima), series='Fitted') #plot
summary(fc_arima) #data
checkresiduals(fc_arima) #residuals = white noise (within blue lines) ?
accuracy(fc_arima, test) #accuracy - ARIMA


# METHOD 11 : Dynamic regression 

# no external data 


# METHOD 12 : Dynamic Harmonic regression

# USing Fourier terms (sums of sin & cos)
# error term to be modeled as a non-seasonal ARIMA process
# assumes the seasonal pattern does not change over time! 
# K decides the "wiggly"-ness of the seasonal pattern
# => try various values for K and select model with lowest AICc value!
# K can not be more than m/2 (= half the seasonal period)
harmonics <- fourier(train, K = 4)
fit <- auto.arima(train, xreg = harmonics, seasonal = FALSE)
newharmonics <- fourier(train, K = 4, h = 6)
fc_harmonic <- forecast(fit, xreg = newharmonics)
summary(fc_harmonic) #data
checkresiduals(fc_harmonic) #residuals = white noise (within blue lines) ?
accuracy(fc_harmonic, test) #accuracy - Dynamic Harmonic Regression (Fourier terms)
# K = 1 : AICc=1212.48 
# K = 2 : AICc=1198.88
# K = 3 : AICc=1197.25
# K = 4 : AICc=1175.57   # lowest AICc
# K = 5 : AICc=1183.08
# K = 6 : AICc=1185.81
autoplot(fc_harmonic) + autolayer(test, series = "Test") + autolayer(fitted(fc_harmonic), series='Fitted') #plot


# METHOD 13 : TBATS

# Trigonometric terms for seasonality
# Box-Cox transformations for heterogeneity
# ARMA errors for short-term dynamics
# Trend (possibly damped)
# Seasonal (including multiple and non-integer periods)
# = very general and handles a large range of time series
# = useful for data with large seasonal periods, and multiple seasonal periods
# entirely automated, but slow for long time series & often too wide prediction intervals
# TBATS(Box-Cox parameter, ARMA error, Damping parameter, <Seasonal period,Fourier terms>)

fc_tbats <- train %>% tbats() %>% forecast(h=6) # forecast
autoplot(fc_tbats) + autolayer(test, series = "Test") + autolayer(fitted(fc_tbats), series='Fitted') #plot
summary(fc_tbats) #data
checkresiduals(fc_tbats) #residuals = white noise (within blue lines) ?
accuracy(fc_tbats, test) #accuracy - TBATS

# METHOD 14 : Theta method
fc_theta <- train %>% thetaf() %>% forecast(h=6) # forecast
autoplot(fc_theta) + autolayer(test, series = "Test") + autolayer(fitted(fc_theta), series='Fitted') #plot
summary(fc_theta) #data
checkresiduals(fc_theta) #residuals = white noise (within blue lines) ?
accuracy(fc_theta, test) #accuracy - Theta 

# METHOD 15 : Cubic Spline method

fc_spline <- train %>% splinef() %>% forecast(h=6) # forecast
autoplot(fc_spline) + autolayer(test, series = "Test") + autolayer(fitted(fc_spline), series='Fitted') #plot
summary(fc_spline) #data
checkresiduals(fc_spline) #residuals = white noise (within blue lines) ?
accuracy(fc_spline, test) #accuracy - Cubic Spline 



# => ARIMA rules !
# ETS close second : litte higher RMSE


# Compare forecast methods - Cross Validation
# Function to return ETS & ARIMA forecasts
fets <- function(x, h) {
  forecast(ets(x), h = h)
}
farima <- function(x, h) {
  forecast(auto.arima(x),h = h, stepwise = FALSE)
}
# Apply tsCV() for both methods
e1 <- tsCV(train, forecastfunction = fets, h = 6)
e2 <- tsCV(train, forecastfunction = snaive, h = 6)
e3 <- tsCV(train, forecastfunction = holt, h = 6)
e4 <- tsCV(train, forecastfunction = hw, h = 6)
e5 <- tsCV(train, forecastfunction = farima, h = 6)
# Compute RMSE of resulting errors : take model with lowest RMSE
sqrt(mean(e1^2, na.rm = TRUE))
sqrt(mean(e2^2, na.rm = TRUE))
sqrt(mean(e3^2, na.rm = TRUE))
sqrt(mean(e4^2, na.rm = TRUE))
sqrt(mean(e5^2, na.rm = TRUE))
# Lowest RMSE after cross validation ?  => ETS (snaive even lower than arima?)



