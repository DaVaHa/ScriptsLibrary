
'''

DECISION TREE & VIZ

'''


# https://www.kdnuggets.com/2019/02/introduction-scikit-learn-gold-standard-python-machine-learning.html

from sklearn.datasets import load_iris
from sklearn import tree

# Load in our dataset
iris_data = load_iris()
print(iris_data)
# Initialize our decision tree object
classification_tree = tree.DecisionTreeClassifier()

# Train our decision tree (tree induction + pruning)
classification_tree = classification_tree.fit(iris_data.data, iris_data.target)

import graphviz 
dot_data = tree.export_graphviz(classification_tree, out_file=None, 
                     feature_names=iris_data.feature_names,  
                     class_names=iris_data.target_names,  
                     filled=True, rounded=True,  
                     special_characters=True)  
graph = graphviz.Source(dot_data)  
graph.render("iris") 