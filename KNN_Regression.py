'''

K Nearest Neighbors : Regression 

https://scikit-learn.org/stable/modules/generated/sklearn.neighbors.KNeighborsRegressor.html

'''

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
#from sklearn.linear_model import LinearRegression
from sklearn.neighbors import KNeighborsRegressor
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score
from sklearn.model_selection import train_test_split
from sklearn.datasets import load_boston, load_diabetes
from sklearn.dummy import DummyRegressor
import statsmodels.api as sm
#import pandas_profiling
#import seaborn as sns



def KNN_Regression(X,Y, neighbors=10, test_size=0.2):
    
    ## Print objective
    print("\n### KNN REGRESSION ### ")
        
    ## Print example data
    print("\n>> X : \n", X.head().to_string(index=False))
    print("\n>> Y : \n", pd.DataFrame(Y).head().to_string(index=False))
    
    print("\nRecords : ", len(Y))

    ## Split data & target into train & test sets
    print("\n>> Splitting data into Train & Test sets...")

    # test if one or more features
    one_feature = isinstance(X, pd.Series)  # if series = one feature
    if isinstance(X, pd.DataFrame):         # if dataframe = one feature ?
        one_feature = len(X.columns) == 1
    
    if one_feature:  # one feature
        
        ### If your data has a single feature : Reshape your data using array.reshape(-1, 1) ###
        ### If your data has a single sample :  Reshape your data using array.reshape(1, -1) ###
        X_train, X_test, y_train, y_test = train_test_split(
                                    X.values.reshape(-1, 1), #reshape in case of one feature
                                    Y, test_size=test_size)
    else: # more than one feature
        X_train, X_test, y_train, y_test = train_test_split(X, Y, test_size=test_size)


    ### SKLEARN ###

    ## Create KNN Regression model
    neigh = KNeighborsRegressor(n_neighbors=neighbors)

    ## Train the model using training sets
    print(">> Training model..")
    neigh.fit(X_train, y_train)

    ## Make predictions using test sets
    print(">> Predicting on test data...")
    y_test_pred = neigh.predict(X_test)
    y_train_pred = neigh.predict(X_train)

    ## The mean absolute error
    print("\n>> Mean absolute error (TRAIN): %.2f" % mean_absolute_error(y_train, y_train_pred))
    print(">> Mean absolute error (TEST):  %.2f\n" % mean_absolute_error(y_test, y_test_pred))

    ## The mean squared error
    print(">> Mean squared error (TRAIN): %.2f" % mean_squared_error(y_train, y_train_pred))
    print(">> Mean squared error (TEST):  %.2f\n" % mean_squared_error(y_test, y_test_pred))

    ## Determination coefficient R²  # = variance explained by model (1 = perfect)
    print('>> Determination coefficient (TRAIN):  %.2f' % neigh.score(X_train, y_train))
    print('>> Determination coefficient (TEST):   %.2f\n' % neigh.score(X_test, y_test))



def Tests():

    # Get data 
    samples = 1000
    bmi = np.random.randint(18,30,size=samples) + np.random.rand()
    height = ( np.random.randint(160,200,size=samples) + np.random.rand()*10 )/ 100
    weight = bmi * height ** 2

    # Create dataframe
    data = pd.DataFrame({'Weight':weight,'BMI': bmi, 'Height':height})
    #print(data.head())

    # Tests
    x = KNN_Regression(data[['Weight','BMI']], data['Height'],test_size=0.3,) # two features
    y = KNN_Regression(data['Weight'], data['Height'],test_size=0.3) # one feature = series
    z = KNN_Regression(data[['Weight']], data['Height'],test_size=0.3) # one feature = df


def TestDatasets():

    # bostont
    boston = load_boston()
    print(boston.DESCR)
    X = pd.DataFrame(boston['data'], columns=boston.feature_names)
    Y = pd.Series(boston['target'], name='MEDIAN_VALUE')
    #print(X.head())
    #print(Y.head())
    #print(X.shape)
    #print(Y.shape)
    KNN_Regression(X,Y)

    # diabetes
    diabetes = load_diabetes()
    print(diabetes.DESCR)
    X = pd.DataFrame(diabetes['data'], columns=diabetes.feature_names)
    Y = pd.Series(diabetes['target'])
    #print(X.head())
    #print(Y.head())
    #print(X.shape)
    #print(Y.shape)
    KNN_Regression(X,Y)
    KNN_Regression(X,Y)
    
if __name__ == "__main__":

    
    Tests()

    TestDatasets()