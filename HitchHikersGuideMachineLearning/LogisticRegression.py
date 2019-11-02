'''

Logistic Regression

https://www.conordewey.com/posts/hitchhikers-guide-machine-learning

Logistic regression is a supervised classification algorithm and therefore
is useful for estimating discrete values. It is typically used for predicting
the probability of an event using the logistic function in order to get
an output between 0 and 1.

'''

from sklearn.linear_model import LogisticRegression
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np

# Load data
df = pd.read_csv('logistic_regression_df.csv')
df.columns = ['X','Y']
print(df.head())
print(df.info())

# Visualize
sns.set_context('notebook', font_scale=1.1)
sns.set_style('ticks')
sns.lmplot('X','Y', data=df, logistic=True)
plt.ylabel('Probability')
plt.xlabel('Explanatory')
plt.show()

# Implementation
logistic = LogisticRegression()
X = (np.asarray(df.X)).reshape(-1, 1)
Y = (np.asarray(df.Y)).ravel()
logistic.fit(X,Y)
logistic.score(X,Y)

print('Coefficient: \n', logistic.coef_)
print('Intercept: \n', logistic.intercept_)
print('R2 Value : \n', logistic.score(X,Y))










