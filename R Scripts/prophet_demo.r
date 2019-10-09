# import R package : prophet
library(prophet)

# import csv file & show results
file_raw <- "https://raw.githubusercontent.com/facebook/prophet/master/examples/example_wp_log_peyton_manning.csv"
df <- read.csv(file =file_raw)
head(df)
tail(df)

# create prophet object
m <- prophet(df)

# create future dataframe for predictions
future <- make_future_dataframe(m, periods = 365)
tail(future)

# predict future data points  
forecast <- predict(m, future)
tail(forecast[c("ds","yhat","yhat_lower","yhat_upper")])

# plot predictions
plot(m, forecast)

# plot trend & seasonality
prophet_plot_components(m, forecast)
