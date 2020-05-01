# Creating dataframe for dates 

# column for weekdays
# column for months

# sequence of date
dates <- seq(as.Date('2020-04-01'), by = 'day', length.out = 60)
df <- data.frame(dates)
df$weekday <- weekdays(df$dates)

head(df)
tail(df)
unique(df$weekday)


df$monday <-    ifelse(df$weekday == "Monday", 1, 0)
df$tuesday <-   ifelse(df$weekday == "Tuesday", 1, 0)
df$wednesday <- ifelse(df$weekday == "Wednesday", 1, 0)
df$thursday <-  ifelse(df$weekday == "Thursday", 1, 0)
df$friday <-    ifelse(df$weekday == "Friday", 1, 0)
df$saturday <-  ifelse(df$weekday == "Saturday", 1, 0)
df$sunday <-    ifelse(df$weekday == "Sunday", 1, 0)

head(df, 40)
