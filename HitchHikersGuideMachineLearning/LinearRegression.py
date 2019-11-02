'''

Linear Regression

https://www.conordewey.com/posts/hitchhikers-guide-machine-learning

Anyways, linear regression is a supervised learning algorithm that predicts an outcome
based on continuous features. Linear regression is versatile in the sense that it has
the ability to be run on a single variable (simple linear regression) or on many features
(multiple linear regression). The way it works is by assigning optimal weights to the variables
in order to create a line (ax + b) that will be used to predict output.

'''

from sklearn import linear_model
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np

# Load data
df = pd.read_csv('linear_regression_df.csv')
df.columns = ['X','Y']
print(df.head())

# Visualize
sns.set_context('notebook', font_scale=1.1)
sns.set_style('ticks')
sns.lmplot('X','Y', data=df)
plt.show()

# Implementation

linear = linear_model.LinearRegression()
trainX = np.asarray(df.X[20:len(df.X)]).reshape(-1, 1)
trainY = np.asarray(df.Y[20:len(df.Y)]).reshape(-1, 1)
testX = np.asarray(df.X[:20]).reshape(-1, 1)
testY = np.asarray(df.Y[:20]).reshape(-1, 1)

linear.fit(trainX, trainY)
linear.score(trainX, trainY)
print("Coefficient: \n", linear.coef_)
print("Intercept: \n", linear.intercept_)
print("R2 Value: \n", linear.score(trainX, trainY))
predicted = linear.predict(testX)
