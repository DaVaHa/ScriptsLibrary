# Forecasting - Combination of models
# https://robjhyndman.com/hyndsight/forecast-combinations/
# https://cran.r-project.org/web/packages/forecastHybrid/vignettes/forecastHybrid.html


library("forecast")
library("ggplot2")
library("fpp2")
library("readxl")
library("forecastHybrid")

# Online Sales - Monthly
path_to_data <- "U:\\MIT\\Python\\OnlineSalesMonthly.xlsx"
data <- read_excel(path_to_data)
myts <- ts(data$OMZET, start = c(2016, 1), frequency = 12)
summary(myts)
#autoplot(myts)
# Split data into train & test
train <- subset(myts, end = length(myts)-6-1) 
test <- subset(myts, start = length(myts)-6, end=length(myts)-1) 
autoplot(train, series="Train") + autolayer(test, series="Test")

## Single models - ETS & ARIMA

fc_ets <- train %>% ets() %>% forecast(h=6) # forecast
autoplot(fc_ets) + autolayer(test, series = "Test") + autolayer(fitted(fc_ets), series='Fitted') #plot
#summary(fc_ets) #data
#checkresiduals(fc_ets) #residuals = white noise (within blue lines) ?
accuracy(fc_ets, test) #accuracy - ETS (Error,Trend,Seasonal)

farima <- function(x, h) {
  forecast(auto.arima(x), h = h)
}
fc_arima <- farima(train, h = 6)
autoplot(fc_arima) + autolayer(test, series = "Test") + autolayer(fitted(fc_arima), series='Fitted') #plot
#summary(fc_arima) #data
#checkresiduals(fc_arima) #residuals = white noise (within blue lines) ?
accuracy(fc_arima, test) #accuracy - ARIMA


?hybridModel
## Combination = better?

fullCombo <- hybridModel(train, weights="equal")
fullCombo$weights
fc_full_combo <- forecast(fullCombo, h = 6)
autoplot(fc_full_combo) + autolayer(test, series = "Test") + autolayer(fitted(fc_full_combo), series='Fitted') #plot
accuracy(fullCombo, test, individual = TRUE) # Full Combo : auto.arima, ets, thetam, nnetar, stlm & tbats
accuracy(fc_full_combo, test) # Full Combo : auto.arima, ets, thetam, nnetar, stlm & tbats

plot(forecast(fullCombo$auto.arima))
plot(forecast(fullCombo$ets))
plot(forecast(fullCombo$thetam))
plot(forecast(fullCombo$nnetar))
plot(forecast(fullCombo$stlm))
plot(forecast(fullCombo$tbats))

# ETS & ARIMA = better?
ets_arima <- hybridModel(train, weights="equal", models="ae") # models = first letters (see ?hybridModel)
ets_arima$weights
fc_ets_arima <- forecast(ets_arima, h = 6)
autoplot(fc_ets_arima) + autolayer(test, series = "Test") + autolayer(fitted(fc_ets_arima), series='Fitted') #plot
accuracy(fc_ets_arima, test) # Combo : ETS & ARIMA

# ETS & ARIMA & TBATS = better?
ets_arima_tbats <- hybridModel(train, weights="equal", models="aet") # models = first letters (see ?hybridModel)
ets_arima_tbats$weights
fc_ets_arima_tbats <- forecast(ets_arima_tbats, h = 6)
autoplot(fc_ets_arima_tbats) + autolayer(test, series = "Test") + autolayer(fitted(fc_ets_arima_tbats), series='Fitted') #plot
accuracy(fc_ets_arima_tbats, test) # Combo : ETS & ARIMA & TBATS

# ets & arima & stlm = better?
aes <- hybridModel(train, weights="equal", models="aes") # models = first letters (see ?hybridModel)
aes$weights
fc_aes <- forecast(aes, h = 6)
autoplot(fc_aes) + autolayer(test, series = "Test") + autolayer(fitted(fc_aes), series='Fitted') #plot
accuracy(fc_aes, test) # Combo : ETS & ARIMA & STLM


