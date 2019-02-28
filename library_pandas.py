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

# load/write/read giant file by chunk
for df in pd.read_csv(path +'data.csv', delimiter='|', chunksize=50000, error_bad_lines=False): # skips bad lines
    df.to_sql("CustomerData", con, if_exists='append') # append to sqlite
	df.to_csv(path + 'export.csv'), mode='a') # append to csv file


# sample data from dataframe
#https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.sample.html
df.sample(frac=0.5)

# correlation matrix
import matplotlib.pyplot as plt
plt.matshow(dataframe.corr())