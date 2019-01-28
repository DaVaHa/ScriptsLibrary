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
