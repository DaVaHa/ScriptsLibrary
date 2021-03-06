'''

Linear Regression

https://scikit-learn.org/stable/modules/generated/sklearn.linear_model.LinearRegression.html
https://stackabuse.com/linear-regression-in-python-with-scikit-learn/

'''

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score
from sklearn.model_selection import train_test_split
from sklearn.datasets import load_boston, load_diabetes
from sklearn.dummy import DummyRegressor
import statsmodels.api as sm
#import pandas_profiling
import seaborn as sns

# Improvements : cross_validation, pandas_profiling, ..?


# function
def LinReg(X, Y, intercept=True, test_size=0.2, correlation=True, statsmodels=True, dummy=True, plot=False):

    ## Print objective
    print("\n### LINEAR REGRESSION ### ")
        
    ## Print example data
    print("\n>> X : \n", X.head().to_string(index=False))
    print("\n>> Y : \n", pd.DataFrame(Y).head().to_string(index=False))
    
    print("\nRecords : ", len(Y))

    ## Pandas Profiling 
    #profile = pandas_profiling.ProfileReport(X.sample(frac=0.3))
    #profile.to_file(outputfile=r"PandasProfiling.html")

    # Correlation matrix
    if correlation == True:
        #print(X.corr())
        df = X.copy()
        df['TARGET'] = Y
        df.corr().to_excel('CorrelationMatrix.xlsx')
        #plt.matshow(X.corr())
        sns.heatmap(df.corr(), annot=True, fmt=".2f")
        plt.show()

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

    ## Create Linear Regression model
    linreg = LinearRegression(fit_intercept=intercept)

    ## Train the model using training sets
    print(">> Training model..")
    linreg.fit(X_train, y_train)

    ## Make predictions using test sets
    print(">> Predicting on test data...")
    y_test_pred = linreg.predict(X_test)
    y_train_pred = linreg.predict(X_train)

    ## Intercept & Coefficients
    #print('Intercept: {}'.format(linreg.intercept_))
    #print('Coefficients: \n', linreg.coef_)

    ## Print Intercept & Coefficients in Dataframe
    intercept = pd.DataFrame(data=[linreg.intercept_], index=['Intercept'],columns=['Coefficient'])
    #print(intercept)
    if one_feature:
        if isinstance(X, pd.DataFrame):
            coeff_df = pd.DataFrame(linreg.coef_, index=[X.columns], columns=['Coefficient'])
        else:    
            coeff_df = pd.DataFrame(linreg.coef_, index=[X.name], columns=['Coefficient'])
    else:
        coeff_df = pd.DataFrame(linreg.coef_, X.columns, columns=['Coefficient'])
    #print(coeff_df)
    coefficients = pd.concat([intercept,coeff_df])
    print('\n>> Coefficients : \n\n', coefficients)

    ## The mean absolute error
    print("\n>> Mean absolute error (TRAIN): %.2f" % mean_absolute_error(y_train, y_train_pred))
    print(">> Mean absolute error (TEST):  %.2f\n" % mean_absolute_error(y_test, y_test_pred))

    ## The mean squared error
    print(">> Mean squared error (TRAIN): %.2f" % mean_squared_error(y_train, y_train_pred))
    print(">> Mean squared error (TEST):  %.2f\n" % mean_squared_error(y_test, y_test_pred))

    ## Determination coefficient R²  # = variance explained by model (1 = perfect)
    print('>> Determination coefficient (TRAIN):  %.2f' % linreg.score(X_train, y_train))
    print('>> Determination coefficient (TEST):   %.2f\n' % linreg.score(X_test, y_test))

    ## Explained variance score: 1 is perfect prediction  (same as above)
    #print('>> Variance score: %.2f' % r2_score(y_test, y_test_pred))

    # score op Dummy model (strategy=mean)
    if dummy == True:
        # Dummy model
        dum = DummyRegressor(strategy="mean")
        dum.fit(X_train, y_train)
        y_pred_dummy = dum.predict(X_test)

        ## The mean absolute error
        print("\n>> Mean absolute error (DUMMY - TEST):  %.2f" % mean_absolute_error(y_test, y_pred_dummy))

        ## The mean squared error
        print(">> Mean squared error (DUMMY - TEST):  %.2f\n" % mean_squared_error(y_test, y_pred_dummy))

        ## Determination coefficient R²  # = variance explained by model (1 = perfect)
        #print('>> Determination coefficient (DUMMY - TEST):   %.2f\n' % dum.score(X_test, y_pred_dummy))

    ### STATSMODELS ###
    
    #https://stackoverflow.com/questions/27928275/find-p-value-significance-in-scikit-learn-linearregression#42677750
    if statsmodels:
        X2 = sm.add_constant(X_train)
        est = sm.OLS(y_train, X2)
        model = est.fit()
        print(model.summary())


    # Plot data & line
    if plot and one_feature:  # one feature
        plt.scatter(X_test, y_test, color='black')
        plt.plot(X_test, y_test_pred, color='blue', linewidth=2)
        plt.show()


    # print examples of predicted vs real 
    print(pd.DataFrame(data={'PREDICTED':y_test_pred, 'REALITY': y_test}).head(10))

    return coefficients



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
    x = LinReg(data[['Weight','BMI']], data['Height'],test_size=0.3,) # two features
    y = LinReg(data['Weight'], data['Height'],test_size=0.3,plot=True) # one feature = series
    z = LinReg(data[['Weight']], data['Height'],test_size=0.3) # one feature = df


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
    LinReg(X,Y)

    # diabetes
    diabetes = load_diabetes()
    print(diabetes.DESCR)
    X = pd.DataFrame(diabetes['data'], columns=diabetes.feature_names)
    Y = pd.Series(diabetes['target'])
    #print(X.head())
    #print(Y.head())
    #print(X.shape)
    #print(Y.shape)
    LinReg(X,Y, statsmodels=False)
    LinReg(X,Y)
    
if __name__ == "__main__":

    
    Tests()

    TestDatasets()
    
    












