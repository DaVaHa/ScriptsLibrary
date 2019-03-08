'''

Support Vector Machines : Regression

https://scikit-learn.org/stable/modules/generated/sklearn.svm.SVR.html
https://scikit-learn.org/stable/auto_examples/svm/plot_svm_regression.html#sphx-glr-auto-examples-svm-plot-svm-regression-py
'''


import numpy as np
from sklearn.svm import SVR
import matplotlib.pyplot as plt
import pandas as pd
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score
from sklearn.model_selection import train_test_split
from sklearn.datasets import load_boston, load_diabetes
from sklearn.dummy import DummyRegressor
import seaborn as sns


"""
Kernels:  ‘linear’, ‘poly’, ‘rbf’, ‘sigmoid’, ‘precomputed’ 
"""


def SVM_Regression(X, Y, test_size=0.2, kernel='rbf', C=1.0, epsilon=0.1):
    
    ## Print objective
    print("\n### SVM REGRESSION ### ")
    print("\n>> Kernel : {}".format(kernel))
    print(">> C : {}".format(C))
    print(">> Epsilon : {}".format(epsilon))

    ## Print example data
    #print("\n>> X : \n", X.head().to_string(index=False))
    #print("\n>> Y : \n", pd.DataFrame(Y).head().to_string(index=False))
    
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

    ## Create SVM Regression model
    svr = SVR(kernel=kernel, C=C, epsilon=epsilon)

    ## Train the model using training sets
    print(">> Training model..")
    svr.fit(X_train, y_train)

    ## Make predictions using test sets
    print(">> Predicting on test data...")
    y_test_pred = svr.predict(X_test)
    y_train_pred = svr.predict(X_train)

    ## The mean absolute error
    print("\n>> Mean absolute error (TRAIN): %.2f" % mean_absolute_error(y_train, y_train_pred))
    print(">> Mean absolute error (TEST):  %.2f\n" % mean_absolute_error(y_test, y_test_pred))

    ## The mean squared error
    print(">> Mean squared error (TRAIN): %.2f" % mean_squared_error(y_train, y_train_pred))
    print(">> Mean squared error (TEST):  %.2f\n" % mean_squared_error(y_test, y_test_pred))

    ## Determination coefficient R²  # = variance explained by model (1 = perfect)
    print('>> Determination coefficient (TRAIN):  %.2f' % svr.score(X_train, y_train))
    print('>> Determination coefficient (TEST):   %.2f\n' % svr.score(X_test, y_test))

    # returns MAE & MSE
    #return mean_absolute_error(y_test, y_test_pred) , mean_squared_error(y_test, y_test_pred)



# ‘linear’, ‘poly’, ‘rbf’, ‘sigmoid’, ‘precomputed’ 
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
    x = SVM_Regression(data[['Weight','BMI']], data['Height'],test_size=0.3,kernel='linear') # two features
    y = SVM_Regression(data['Weight'], data['Height'],test_size=0.3) # one feature = series
    z = SVM_Regression(data[['Weight']], data['Height'],test_size=0.3,kernel='poly') # one feature = df


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
    SVM_Regression(X,Y,kernel='sigmoid')

    # diabetes
    diabetes = load_diabetes()
    print(diabetes.DESCR)
    X = pd.DataFrame(diabetes['data'], columns=diabetes.feature_names)
    Y = pd.Series(diabetes['target'])
    #print(X.head())
    #print(Y.head())
    #print(X.shape)
    #print(Y.shape)
    SVM_Regression(X,Y)
    SVM_Regression(X,Y)
    
if __name__ == "__main__":

    
    Tests()

    TestDatasets()
