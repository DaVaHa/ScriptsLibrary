'''

Shuffling

https://www.youtube.com/watch?v=Iq9DzN6mvYA

=> Works when Null Hypothesis assumes two groups are equivalent
=> Like all methods, it will only work if your samples are representative!
=> Always be careful about selection biases!


DEFINITIONS:
Null hypothesis (H0) 
A hypothesis associated with a contradiction to a theory one would like to prove.

Alternative hypothesis (H1) 
A hypothesis (often composite) associated with a theory one would like to prove.

p-value
The probability, assuming the null hypothesis is true, of observing a result at least
as extreme as the test statistic.

Example:
You think there is a difference in mean between two samples.
Null hypothesis is opposite so assumes means are equal.
P-value will show probability of observing samples, assuming Null hypothesis (=equal means).
Using Youtube example: 16% probability the sample difference comes from distributions with equal mean.
16% is not smaller than 5% so insufficient evidence for saying means are different.

'''

import random
import numpy as np

## TEST DATA ##
# YOUTUBE : STATISTICS FOR HACKERS
test_set_1 = [84,57,63,99,72,46,76,91]  #youtube
test_set_2 = [81,74,56,69,66,62,69,61,87,65,44,69]  #youtube

test_set_1 = [84,77,63,99,72,66,76,91] #test
test_set_2 = [81,74,56,69,66,62,69,61,87,65,44,69] #test

original_mean = np.mean(test_set_1) - np.mean(test_set_2)

#print("Mean 1 : {}".format(round(np.mean(test_set_1),4)))
#print("Mean 2 : {}".format(round(np.mean(test_set_2),4)))
#print("Difference : {}".format(round(original_mean,4)))


## STATSMODELS ##
"""
http://www.statsmodels.org/dev/generated/statsmodels.stats.weightstats.ttest_ind.html
"""
from statsmodels.stats.weightstats import ttest_ind

# t = test statistic
# p = p-value of t-test
# dof = degrees of freedom used in t-test
t, p, dof = ttest_ind(test_set_1, test_set_2, alternative='larger', usevar='unequal')

#print(t)
print("P-value is : {} (STATSMODELS)".format(round(p,4)))
#print(dof)



## HACKING WAY ##

"""
IDEA : Simulate the distribution by shuffling the labels
repeatedly and computing the desired statistic.

MOTIVATION: If the labels really don't matter, then
switching them shouldn't change the result!

NULL HYPOTHESIS: Statistic 1 == Statistic 2

EXAMPLE: calculate mean of two groups
=> means significantly different?
=> Null Hypothesis : mean 1 ==  mean 2
=> create distribution by shuffling:
 1. reshuffle observations
 2. calculate means
 3. add means to distribution
=> calculate p-value (distribution >= original-means)

RESULT:
=> p < 0.05
- Reject null hypothesis
- Significant difference in means!
=> p > 0.05
- CAN NOT reject null hypothesis
- No significant difference in means!

"""


# Combine both samples
group = test_set_1 + test_set_2
#print("Length of samples OK? == {}".format(len(group) == len(test_set_1) + len(test_set_2)))

# Length of sample 1
length = len(test_set_1)

# Shuffle 10.000 times
distribution = []
for i in range(10000):
    #print("\nshuffle : {}".format(i))
    # shuffle all observations
    random.shuffle(group)
    # mean of two reshuffled samples
    mean_1 = np.mean(group[:length])
    mean_2 = np.mean(group[length:])
    # add difference to list
    distribution.append(mean_1 - mean_2)
    
    #print(group[:5])
    #print(mean_1, mean_2)
    #print(distribution)


# Number of new statistics differences
diffs = [d for d in distribution if d >= original_mean]

#print(len(diffs))
#print(len(distribution))

pvalue = len(diffs)/len(distribution)

print("P-value is : {} (HACKING WAY)".format(round(pvalue,4)))

















