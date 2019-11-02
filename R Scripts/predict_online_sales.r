'
Prediction Online Sales

- Marketing Actions?
 
'

# import R package : prophet
library(prophet)

# import csv file
df <- read.csv('U:\\MIT\\Python\\ScriptsLibrary\\R Scripts\\OnlineSales.csv')
head(df)
tail(df)

# convert column to datetime
df[['ds']] <- as.POSIXct(strptime(df[['TRANSDATE_WID']], format='%Y%m%d'))

# change column name
names(df)[3] <- 'y'


# create dataset
data <- df[order(df$TRANSDATE_WID),][c("ds","y")]
head(data)
tail(data)

# check dataframe
str(data)


# create prophet object
m <- prophet(data)

# create future dataframe for predictions
future <- make_future_dataframe(m, periods = 30)
tail(future)

# predict future data points
forecast <- predict(m, future)
tail(forecast[c("ds","yhat","yhat_lower","yhat_upper")])
head(forecast[c("ds","yhat","yhat_lower","yhat_upper")])

# plot predictions
plot(m, forecast)

# plot trend & seasonality
prophet_plot_components(m, forecast)

