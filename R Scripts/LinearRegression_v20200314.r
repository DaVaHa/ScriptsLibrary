###########################
##                       ##
##   LINEAR REGRESSION   ##
##                       ##
###########################


### Set parameters ###

# 1. Path to csv file
csv_file <- 'U:\\MIT\\Python\\ScriptsLibrary\\R Scripts\\clvData1.csv'

# 2. Set to FALSE to not show results
show_basic_info <- TRUE            # shows data types & first 6 rows
show_summary_stats <- TRUE          # shows min, Q1, median, mean, Q3 & max
show_correlation_matrix <- TRUE    # shows correlation matrix for numeric columns only
show_missing_data <- TRUE          # shows overview of missing data
show_cooks_distance <- TRUE         # shows observations and cut off line
show_model_output <- TRUE           # shows result of linear regression
show_vifs <- TRUE                  # shows VIFs after linear model

# 3. Filter dataset based on list of conditions
filter_conditions <- c(  
  #expression (nOrders > 2)
  #expression (age == 30)
) # example = "expression (nOrders < 5)"

# 4. Dealing with missing data
# if FALSE, regression will by default delete rows with missing data
impute_missing_data <- FALSE      # will impute all NA values using "predictive mean matching" method

# 5. Drop outliers
drop_outliers <- TRUE             # will drop all outliers 
outlier_cutoff <- 4               # outlier = Cook's Distance > X * mean

# 6. Run Linear Regression
run_linear_regression <- TRUE     # set to TRUE to run linear regression
train_data <- 1.00                # % of data used for training model, rest is for testing statistics
target_column <- 'futureMargin'   # target column
columns_not_to_use <- c(
  'nItems',
  'marginPerOrder'
)



### script ###

# Import packages
library(dplyr)
library(tidyverse)
library(corrplot)


# 1. Load csv data
data <- read.csv(csv_file)

# 2. Show data types & example data
if (show_basic_info) {
  str(data)  # shows columns & data types
  head(data) # shows first 6 rows
}

# Show summary statistics for every column
if (show_summary_stats) {
  summary(data) # shows min, Q1, median, mean, Q3 & max
}

# Show correlation matrix - only for numeric columns
if (show_correlation_matrix) {
  data %>% dplyr :: select( names(dplyr::select_if(data, is.numeric)) )  %>% 
    cor() %>% corrplot()
}

# 3. Filter dataset based on conditions
for (filter in filter_conditions) {
  data <- subset(data, eval(filter))
  str(data)
}

# Test to remove some data
#data <- data %>% mutate_at(vars(nOrders, nItems), na_if, 4)

# Show overview of missing data
if (show_missing_data) {
  
  # Visualize missing data
  library(mice)
  md.pattern(data)

  library(VIM)
  aggr_plot <- aggr(data, 
                    col=c('navyblue','red'), 
                    numbers=TRUE, 
                    sortVars=TRUE, 
                    labels=names(data), 
                    cex.axis=.7, gap=3, 
                    ylab=c("Histogram of missing data","Pattern"))
}

# 4. Impute missing data : FALSE = remove rows with NA (by default)
if (impute_missing_data) {
  imputed_data <- mice(data)                # default imputing method : predictive mean matching
  data <- mice::complete(imputed_data)      # default : 1st dataset
}


# 6. Run regression model
if (run_linear_regression) {
  
  print('>> Running Linear Regression...')
  # Split training and test set
  data$isTrain <- rbinom(nrow(data), 1, train_data) # training & test data
  train <- subset(data, data$isTrain == 1)
  test <- subset(data, data$isTrain == 0)
  
  # Train linear regression model on training data
  if (is.null(columns_not_to_use)){
    skip_columns <- ''
  } else {
    skip_columns <- paste(columns_not_to_use, collapse='', seq=' - ')
  } 
  formula_linreg <- as.formula(paste(target_column, '~ . - isTrain -', skip_columns, target_column))
  linReg <- lm(formula_linreg, data = train)
  #summary(linReg)
  
  # 5. Remove outliers
  if (drop_outliers) {
    
    # Calculate Cook's distance & cutoff
    cooksd <- cooks.distance(linReg)
    cutoff <- outlier_cutoff * mean(cooksd, na.rm=TRUE)
    
    # Plot observations and cutoff line
    if (show_cooks_distance){
      plot(cooksd, pch="*", cex=2, main="Influential Obs by Cook's distance")  # plot cook's distance
      abline(h = cutoff, col="red")  # cutoff line = 4 x mean
    }
    
    # Remove if Cook's distance > cutoff
    data_outliers <- as.numeric(names(cooksd)[(cooksd > cutoff)])
    data_excl_outliers <- train[-data_outliers, ]
    
    # Rerun linear regression
    linReg <- lm(formula_linreg, data = data_excl_outliers)
  }
  
  print('>> Finished running the model.')
  # p value < 0.05 = significant coefficient (= coefficient significantly different from 0)
  # F-test : test if R-squared is significantly different from 0 (= if model is useful or not) # p < 0.05 = useful model
  if (show_model_output) {
    summary(linReg)
  }
}
  
# Variance Inflation Factor (VIF)
# VIF = 1 means not correlated ; VIF = 5 means highly correlated (& should be removed from predictors)
# Detects multicollinearity : how much the variance of coefficients is inflated because of correlation between predictors of the model
if (show_vifs) {
  library(rms)
  vif(linReg)
}


# Cross validation (to avoid overfitting)
#library(DAAG)
#cv.lm(data, linReg, m=3, dots = FALSE, seed=29, plotit=FALSE, printit=TRUE)

# AIC test statistic
# The smaller the better : if comparing models, take model with smallest AIC value
#AIC(linReg)

# Automatic model selection based on (lowest) AIC value
# = adds or removes variables one by one and returns (reduced) model with lowest AIC value
#library(MASS)
#linregAuto <- stepAIC(linReg, trace = 0) # hide intermediate steps with trace = 0
#AIC(linregAuto)
#summary(linregAuto)

