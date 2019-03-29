'''

Tricks on Python Library : Auto Sklearn (only runs on Linux...)

https://www.automl.org/automl/auto-sklearn/
https://automl.github.io/auto-sklearn/stable/

pip install auto-sklearn
'''


>>> import autosklearn.classification
>>> cls = autosklearn.classification.AutoSklearnClassifier()
>>> cls.fit(X_train, y_train)
>>> predictions = cls.predict(X_test, y_test)