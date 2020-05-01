# Store Item Demand Challenge #

# Trial 2 : output with Dynamic Regression - TBATS #

library("xts")
library("forecast")
library("ggplot2")
library("readxl")
library("dplyr")

## DATA ##
path_to_dir <- "C:\\Users\\daniel.vanhasselt.JBC\\Desktop\\Kaggle\\Competitions\\StoreItemDemandChallenge\\"
sample <- read.csv(paste(path_to_dir, "sample_submission.csv", sep=""))
head(sample)

train <- read.csv(paste(path_to_dir, "train.csv", sep=""))
head(train)
tail(train)
unique(train$store)
unique(train$item)
unique(data.frame(train$store, train$item))
str(train)

test <- read.csv(paste(path_to_dir, "test.csv", sep=""))
head(test,120)
tail(test)
unique(test$store)
unique(test$item)

# Data example :
#       train.store train.item
# 1                1          1
# 1827             2          1
# 3653             3          1
# 5479             4          1
# 7305             5          1
# 9131             6          1
# 10957            7          1
# 12783            8          1
# 14609            9          1
# 16435           10          1
# 18261            1          2
# 20087            2          2
# 21913            3          2
# 23739            4          2

# Add weekdays to train & test data
train$weekday <- weekdays(as.Date(train$date))
head(train)
tail(train)
unique(train$weekday)
train$monday <-    ifelse(train$weekday == "Monday", 1, 0)
train$tuesday <-   ifelse(train$weekday == "Tuesday", 1, 0)
train$wednesday <- ifelse(train$weekday == "Wednesday", 1, 0)
train$thursday <-  ifelse(train$weekday == "Thursday", 1, 0)
train$friday <-    ifelse(train$weekday == "Friday", 1, 0)
train$saturday <-  ifelse(train$weekday == "Saturday", 1, 0)
train$sunday <-    ifelse(train$weekday == "Sunday", 1, 0)
head(train, 40)
str(train)

test$weekday <- weekdays(as.Date(test$date))
head(test)
tail(test)
unique(test$weekday)
test$monday <-    ifelse(test$weekday == "Monday", 1, 0)
test$tuesday <-   ifelse(test$weekday == "Tuesday", 1, 0)
test$wednesday <- ifelse(test$weekday == "Wednesday", 1, 0)
test$thursday <-  ifelse(test$weekday == "Thursday", 1, 0)
test$friday <-    ifelse(test$weekday == "Friday", 1, 0)
test$saturday <-  ifelse(test$weekday == "Saturday", 1, 0)
test$sunday <-    ifelse(test$weekday == "Sunday", 1, 0)
head(test, 40)
str(test)

### Loop over every product : 1 to 50
### Loop over every store : 1 to 10
### forecast to data.frame


# create full dataframe
full_df <- data.frame("sales"=NA,"date"=NA,"store"=NA,"item"=NA)
full_df <- na.omit(full_df)
str(full_df)
full_df


# function to forecast based on product & store
forecastDemand <- function(item, store) {
  
  # filter product & store 
  product <- train[train$store == store & train$item == item,]
  #unique(product$store)
  #unique(product$item)
  myts <- ts(data = product$sales, start = c(2013,1,1), frequency = 365)
  #autoplot(myts)
  
  product_test <- test[test$store == store & test$item == item,]
  
  # forecast : Dynamic regression
  
  # (1) Build linear regression model 
  col_names <- c("monday","tuesday","wednesday","thursday","friday","saturday","sunday")
  lm_model <- lm(sales ~ . , data = product[, append(c("sales"),col_names)])
  #summary(lm_model)
  
  # predict sales based on linear regression
  lm_pred <- predict(lm_model, product_test[, col_names])
  lm_prediction <- xts(lm_pred, order.by = as.Date(product_test$date))
  #autoplot(lm_prediction)

  # (2) Build time series model on residuals
  #model_res <- xts(residuals(lm_model), order.by = as.Date(product$date))
  model_res <- ts(residuals(lm_model), start = c(2013,1, 1), frequency=365)
  #autoplot(model_res)
  #hist(model_res)
  
  # time series : tbats & one-step forecasts
  ts_model <- tbats(model_res)
  #summary(ts_model)

  ts_fcst <- forecast(ts_model, h = 90) 
  #autoplot(ts_fcst) + autolayer(fitted(ts_model), series = 'Fitted')
  ts_forecast <- xts(ts_fcst$mean, order.by = as.Date(product_test$date))
  
  # (3) Combine regression & time series
  fcst_final <- lm_prediction + ts_forecast
  #autoplot(fcst_final)
  #print(autoplot(ts(as.vector(coredata(fcst_final)), start=c(2018,1,1), frequency=365)) + autolayer(myts))
  
  # (4) result
  res_df <- data.frame("sales" = as.vector(coredata(fcst_final)))
  res_df$date <- seq(as.Date("2018-01-01"), by = "day", length.out = 90)
  res_df$store <- store
  res_df$item <- item
  
  # add to full dataframe : <<- for global variable
  full_df <<- rbind(full_df, res_df)
  
}

# loop over all products
for (i in 1:50) { # items
  for (st in 1:10) { # stores
    
    # print data
    x <- c("Store : ",st, " - Product : ", i)
    print(paste(x, collapse="")) 
    
    # run function
    forecastDemand(i, st)
  }
}


# Check results
unique(full_df$store)
unique(full_df$item)

head(full_df)
tail(full_df)

head(unique(data.frame(test$store, test$item)),30)
head(unique(data.frame(full_df$store, full_df$item)),30)

tail(unique(data.frame(test$store, test$item)),30)
tail(unique(data.frame(full_df$store, full_df$item)),30)

str(test)
str(full_df)

# Export data
full_df$id <- seq(1:45000) - 1
head(full_df)
str(full_df)

write.csv( full_df[, c("id","sales")], paste(path_to_dir, "trial_2_dynamic_regression.csv", sep=""), row.names=FALSE)

full_df$sales_round <- round(full_df$sales)

write.csv( full_df[, c("id","sales_round")], paste(path_to_dir, "trial_2_dynamic_regression_rounded.csv", sep=""), row.names=FALSE)

# check
#write.csv( full_df, paste(path_to_dir, "trial_2_dynamic_regression_full.csv", sep=""), row.names=FALSE)


# Seasonal Naive
# sMAPE :  28.80907
# Kaggle : 84.42508

# Dynamic Regression & TBATS
# sMAPE : ?
# KAggle : 15.61983

# Dynamic Regression & TBATS - Rounded
# sMAPE : ?
# KAggle : 15.59470




