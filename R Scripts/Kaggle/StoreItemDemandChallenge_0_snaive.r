# Store Item Demand Challenge #

# Trial 1 : output with Seasonal Naive #

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
test <- read.csv(paste(path_to_dir, "test.csv", sep=""))
head(test)
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
  product <- train %>% filter((train$store == item) & (train$item == store))
  #unique(product$store)
  #unique(product$item)
  myts <- ts(data = product$sales, start = c(2013,1,1), end = c(2017,12,31), frequency = 365)
  #myts
  #print(autoplot(myts))

  # forecast : Seasonal Naive
  fcst <- snaive(myts, h = 90)
  fcst$mean
  
  # result
  res_df <- data.frame("sales" = as.numeric(fcst$mean))
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

write.csv( full_df[, c("id","sales")], paste(path_to_dir, "trial_0_snaive.csv", sep=""), row.names=FALSE)

write.csv( full_df, paste(path_to_dir, "trial_0_snaive_full.csv", sep=""), row.names=FALSE)


# Seasonal Naive
# sMAPE :  28.80907
# Kaggle : 84.42508



