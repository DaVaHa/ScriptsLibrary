'''

Tricks on Python Library : Auto Sklearn

https://www.automl.org/automl/auto-sklearn/

'''


>>> import autosklearn.classification
>>> cls = autosklearn.classification.AutoSklearnClassifier()
>>> cls.fit(X_train, y_train)
>>> predictions = cls.predict(X_test, y_test)