############################
##                        ##
##      FORECASTING       ##
##                        ##
############################

# install.packages("forecast")

library("forecast")
library("ggplot2")
library("fpp2")

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



