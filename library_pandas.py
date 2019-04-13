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


# copy dataframe
# https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.copy.html
df_copy = df.copy() # (!) NOT df_copy = df (!) -> Changes to the original will be reflected in the shallow copy (and vice versa) (!)


# dataframe plot : two lines in same plot
ax = df1.plot(x="year",y="proportion_deaths", label="clinic 1")
df2.plot(x="year", y="proportion_deaths", label="clinic 2", ax=ax)  # notice ax variable!
ax.set_ylabel("Proportion deaths")


# bootstrapping of dataframe column
# = quantifying uncertainty of estimate
# = simulating data collection number of times by drawing randomly from data with replacement
# A bootstrap analysis of the reduction of deaths due to handwashing
boot_mean_diff = []
for i in range(3000):
    boot_before = before_proportion.sample(frac=1, replace=True) # bootstrapping of full column &
    boot_after = after_proportion.sample(frac=1, replace=True) # & with replacement
    boot_mean_diff.append( boot_after.mean() - boot_before.mean() )  # avg differences in list

# Calculating a 95% confidence interval from boot_mean_diff 
confidence_interval = pd.Series(boot_mean_diff).quantile([0.025, 0.975]) # from list to pd.Series
confidence_interval

# value count of column
df.column_name.value_counts().sort_index()


