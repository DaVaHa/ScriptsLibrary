'''

Tricks on Python Library : SEABORN

'''

import seaborn as sns
import matplotlib.pyplot as plt

# DIST PLOT # = histogram + distribution line
#https://seaborn.pydata.org/generated/seaborn.distplot.html
import numpy as np
x = np.random.randint(0,10,1000)
sns.distplot(x)
plt.show()


# correlation matrix
# https://seaborn.pydata.org/generated/seaborn.heatmap.html
sns.heatmap(flights, annot=True, fmt="d")
plt.show()


# scatterplot + regression line
# https://seaborn.pydata.org/tutorial/regression.html
# https://seaborn.pydata.org/generated/seaborn.regplot.html
import seaborn as sns; sns.set(color_codes=True)
tips = sns.load_dataset("tips")
ax = sns.regplot(x="total_bill", y="tip", data=tips)
