'''
Test normal distribution of array.
'''

import numpy as np
import scipy.stats as stats  # Null Hypothesis = Normal Distribution
import math
import matplotlib.pyplot as plt

# random age distribution
age = np.random.randint(18,60, size=10000)  # random integers
age_norm = np.random.normal(45,20, 10000)  # random normal 

# show distribution
plt.hist(age, bins=50)
plt.show()

plt.hist(age_norm, bins=50)
plt.show()

# normaltest
print("\nRandom test:")
results = stats.normaltest(age)   # p-value > 0.05 : Normal Distribution
print(results)

print("\nNormal Distributed Random test:")
results = stats.normaltest(age_norm)
print(results)


# log of variables
age_log = np.log(age)

print("\nRandom test (LOG):")
results = stats.normaltest(age_log)   # p-value > 0.05 : Normal Distribution
print(results)

# use math.exp() to reverse log function
avg = math.exp(np.mean(age_log))
print("Average LOG:{}".format(avg))
