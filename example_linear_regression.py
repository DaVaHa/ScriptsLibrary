'''

Linear Regression : example

https://scikit-learn.org/stable/modules/generated/sklearn.linear_model.LinearRegression.html
https://stackabuse.com/linear-regression-in-python-with-scikit-learn/

'''

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score
from sklearn.model_selection import train_test_split

# https://scikit-learn.org/stable/auto_examples/linear_model/plot_ols.html#sphx-glr-auto-examples-linear-model-plot-ols-py

# Get data 
samples = 100
bmi = np.random.randint(18,30,size=samples) + np.random.rand()
height = ( np.random.randint(160,200,size=samples) + np.random.rand()*10 )/ 100
weight = bmi * height ** 2

# Create dataframe
data = pd.DataFrame({'Weight':weight, 'Height':height})
#print(data.info())
#print(data.head())

# Split data & target into train & test sets
X_train, X_test, y_train, y_test = train_test_split(
                                data['Weight'].values.reshape(-1, 1), #reshape in case of one feature
                                data['Height'],
                                test_size=0.2)

### Reshape your data either using array.reshape(-1, 1) if your data has a single feature ###
### or array.reshape(1, -1) if it contains a single sample. ###

# Create Linear Regression model
linreg = LinearRegression()

# Train the model using training sets
linreg.fit(X_train, y_train)

# Make predictions using test sets
y_pred = linreg.predict(X_test)


# Intercept & Coefficients
print('Intercept: {}'.format(linreg.intercept_))
print('Coefficients: \n', linreg.coef_)

# Print Coefficients in Dataframe
coeff_df = pd.DataFrame(linreg.coef_, data[['Weight']].columns, columns=['Coefficient'])
print(coeff_df)

# The mean absolute error
print("Mean absolute error: %.2f" % mean_absolute_error(y_test, y_pred))

# The mean squared error
print("Mean squared error: %.2f" % mean_squared_error(y_test, y_pred))

# Determination coefficient R²  # = variance explained by model (1 = perfect)
print('Determination coefficient:  %.2f' % linreg.score(X_test, y_test))

# Explained variance score: 1 is perfect prediction  (same as above)
print('Variance score: %.2f' % r2_score(y_test, y_pred))

# Plot data & line
plt.scatter(weight, height, color='black')
plt.plot(X_test, y_pred, color='blue', linewidth=2)
plt.show()










