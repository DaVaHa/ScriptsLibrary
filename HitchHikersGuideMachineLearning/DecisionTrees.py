'''

Decision Trees

https://www.conordewey.com/posts/hitchhikers-guide-machine-learning

Decision trees are a form of supervised learning that can be used for
both classification and regression purposes. In my experience, they are
typically utilized for classification purposes. The model takes in an instance
and then goes down the tree, testing significant features against a
determined conditional statement. Depending on the result, it will go down
to the left or right child branch and onward after that. Typically the most
significant features in the process will fall closer to the root of the tree.

'''

from sklearn import tree
from sklearn.cross_validation import train_test_split
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np

# Load data
df = pd.read_csv('iris_df.csv')
df.columns = ['X1','X2','X3','X4','Y']
print(df.head())
print(df.info())

# Implementation
decision = tree.DecisionTreeClassifier(criterion='gini')

X = df.values[:, 0:4]
Y = df.values[:, 4]

trainX, testX, trainY, testY = train_test_split(X, Y, test_size = 0.3)
decision.fit(trainX, trainY)
print('Accuracy: \n', decision.score(testX, testY))



# Visualize
from sklearn.externals.six import StringIO
import pydotplus as pydot
import sys
sys.path.insert(0, "U://MIT//Python//ScriptsLibrary//HitchHikersGuideMachineLearning")

dot_data = StringIO()
dot_data = tree.export_graphviz(decision, out_file=None)
graph = pydot.graph_from_dot_data(dot_data)

# Notebook
#from IPython.display import Image
#Image(graph.create_png())

# error here ?!
graph.write_png("tree.png")









