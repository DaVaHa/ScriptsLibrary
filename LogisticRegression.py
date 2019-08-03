'''

How to properly do a Logistic Regression, yeah.


'''


import pandas as pd
import numpy as np
from sklearn.datasets import load_iris, load_digits, load_breast_cancer

from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split, cross_val_score, GridSearchCV
from sklearn.metrics import classification_report, confusion_matrix, roc_auc_score, precision_score


#data = load_iris()
#df = pd.DataFrame(data.data, columns=data.feature_names)
#print(df.head())

##digits = load_digits()
##print(digits.data.shape)
##
##import matplotlib.pyplot as plt 
##plt.gray() 
##plt.matshow(digits.images[0]) 
##plt.show() 

print("\n>> LOGISTIC REGRESSION <<\n")

# Load data
cancer = load_breast_cancer()

X = pd.DataFrame(cancer.data, columns=cancer.feature_names)
y = cancer.target
#print(X.info())

# Instantiate Logistic Regression
# https://scikit-learn.org/stable/modules/generated/sklearn.linear_model.LogisticRegression.html
logreg = LogisticRegression()

# Split data into train & test
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=43)

# Train model on training data
logreg.fit(X_train, y_train)

# Predict labels of test set
y_pred = logreg.predict(X_test)

# Parameters of model
print("Parameters: \n{}".format(logreg.get_params))

# Metric : Accuracy of train & test
# Accuracy = (TP+TN)/(TP+TN+FP+FN)
print("\nAccuracy - TRAIN : {:.4f}".format(logreg.score(X_train, y_train)))
print("Accuracy - TEST  : {:.4f}".format(logreg.score(X_test, y_test)))

# Metric : Precision score
# Precision = (TP)/(TP+FP)
print("\nPrecision - TEST  : {:.4f}".format(precision_score(y_test, y_pred)))

# Metric : Confusion matrix
# https://scikit-learn.org/0.17/modules/generated/sklearn.metrics.confusion_matrix.html
# First row : TN FP // Second row : FN TP
print("\nConfusion Matrix TEST:\n", confusion_matrix(y_test, y_pred))

# Metric : Classification report
#print("Classification Report :\n", classification_report(y_test, y_pred))

## AUC score (Area Under Curve) (AUC of 0.5 = random guessing)
# https://scikit-learn.org/stable/modules/generated/sklearn.metrics.roc_auc_score.html
y_pred_prob = logreg.predict_proba(X_test)[:,1] # Probability of 1
print("\nAUC Score TEST: {:.4f}".format(roc_auc_score(y_test, y_pred_prob)))

# Cross validation
# https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.cross_val_score.html
cv_scores = cross_val_score(logreg, X, y, cv=5, scoring='roc_auc')
print("Cross Validated Score : {:.4f}".format(np.mean(cv_scores)))

# Output Predictions from full dataset
probabilities = pd.DataFrame(logreg.predict_proba(X)[:,1])  # Probability of 1
predictions = pd.Series(logreg.predict(X))
output = pd.concat([X, pd.Series(y), probabilities, predictions], axis=1, ignore_index=True)

#print(output.info())
#print(output.head())



## GridSearch ##
print("\n> GridSearchCV <")
c_space = np.logspace(-5, 8, 15)  # regularization hyperparameter space
penalty = ['l1', 'l2']  # regularization penalty space
param_grid = {'C': c_space, 'penalty': penalty}
clf = GridSearchCV(logreg, param_grid, cv=5)
best_model = clf.fit(X_train, y_train)
bm_pred = best_model.predict(X_test)

# View best hyperparameters
print('\nBest model - Penalty:', best_model.get_params()['estimator__penalty'])
print('Best model - C:', best_model.get_params()['estimator__C'])
print("\nBest model - Accuracy TRAIN : {:.4f}".format(best_model.score(X_train, y_train)))
print("Best model - Accuracy TEST  : {:.4f}".format(best_model.score(X_test, y_test)))


# Output Predictions from full dataset
best_probabilities = pd.DataFrame(best_model.predict_proba(X)[:,1])  # Probability of 1
best_predictions = pd.Series(best_model.predict(X))
best_output = pd.concat([X, pd.Series(y), best_probabilities, best_predictions], axis=1, ignore_index=True)

#print(best_output.info())
#print(best_output.head())




print("\n>> Done.\n")




