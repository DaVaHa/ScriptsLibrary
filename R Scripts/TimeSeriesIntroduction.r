## DATACAMP - TIME SERIES INTRODUCTION


library(dplyr)

# import csv file
df <- read.csv('U:\\MIT\\Python\\ScriptsLibrary\\R Scripts\\OnlineSales.csv')

# order by date ascending
df <- df[order(df$TRANSDATE_WID),]
head(df)
tail(df)
str(df)

# Create time series object : index by day
start <- as.Date(as.character(min(df$TRANSDATE_WID)), format = "%Y%m%d") # min of column
end <- as.Date(as.character(max(df$TRANSDATE_WID)), format = "%Y%m%d") # max of column
inds <- seq(start, end, by = "day")
head(inds)
tail(inds)

## Create a time series object : ts 
sales <- ts( df$OMZET,
             start = c(2015, as.numeric(format(inds[1], "%j"))), # figuring out what day of year 1st observation is
             frequency = 365)
is.ts(sales)

# plot time series data
typeof(sales)
ts.plot(sales)


# Simulate White Noise (WN) model : ARIMA(0,0,0)
WN_1 <- arima.sim(model = list(order = c(0, 0, 0)), n = 250, mean = 4, sd = 5)
ts.plot(WN_1)

# Random Walk (RW) model : ARIMA(0,1,0) (= recursive white noise data)
# no fixed mean or variance, strong dependence over time & changes/increments are white noise (WN)
random_walk <- arima.sim(model = list(order = c(0,1,0)), n = 100, mean = 0) # mean != 0 : drift
ts.plot(random_walk)






