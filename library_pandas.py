'''

Tricks on Python Library : Pandas

'''

import pandas as pd
import numpy as np


# create Dataframe from numpy arrays
bmi = np.random.randint(18,30,size=100)
height = np.random.randint(165,195,size=100) / 100
weight = bmi * height ** 2

df = pd.DataFrame({'Weight':weight, 'Height':height})

# concatenate dataframes
#https://pandas.pydata.org/pandas-docs/stable/user_guide/merging.html
df1 = DataFrame()
df2 = DataFrame()
df3 = DataFrame()
frames = [df1,df2,df3]
result = pd.concat(frames)

# print dataframe without index
df.to_string(index=False))
