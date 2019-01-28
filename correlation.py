'''

## Pearson Correlation & Significance ##

https://docs.scipy.org/doc/scipy-0.14.0/reference/generated/scipy.stats.pearsonr.html

scipy.stats.pearsonr(x, y)[source]
Calculates a Pearson correlation coefficient and the p-value for testing non-correlation.

The Pearson correlation coefficient measures the linear relationship between two datasets.
Strictly speaking, Pearson’s correlation requires that each dataset be normally distributed.
Like other correlation coefficients, this one varies between -1 and +1 with 0 implying no correlation.
Correlations of -1 or +1 imply an exact linear relationship.
Positive correlations imply that as x increases, so does y.
Negative correlations imply that as x increases, y decreases.

The p-value roughly indicates the probability of an uncorrelated system producing datasets
that have a Pearson correlation at least as extreme as the one computed from these datasets.
The p-values are not entirely reliable but are probably reasonable for datasets larger than 500 or so.



Parameters:	
x : (N,) array_like
y : (N,) array_like

Returns:	
(Pearson’s correlation coefficient, 2-tailed p-value)


EXPLANATION:
http://janda.org/c10/Lectures/topic06/L24-significanceR.htm

## The smaller the p-level, the more significant the relationship ##

- a relationship can be strong and yet not significant 
- a relationship can be weak but significant

## The key factor is the size of the sample. ##

- For small samples, it is easy to produce a strong correlation by chance and
one must pay attention to signficance to keep from jumping to conclusions:
i.e. rejecting a true null hypothesis, which means making a Type I error.
(=saying correlation is different from 0 while there isn't)
- For large samples, it is easy to achieve significance, and one must pay attention
to the strength of the correlation to determine if the relationship explains very much.

'''


from scipy.stats import pearsonr
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns


### DISTRIBUTION CORRELATION & P-VALUES ###

# https://docs.scipy.org/doc/numpy-1.15.0/reference/generated/numpy.random.rand.html
# https://docs.scipy.org/doc/numpy-1.15.0/reference/generated/numpy.random.normal.html
# https://docs.scipy.org/doc/numpy-1.15.1/reference/generated/numpy.random.gamma.html

print(">> Running examples...")
correlations = []
pvalues = []
for i in range(1000):

    # uniform distribution
    t1 = np.random.rand(1000)
    #t2 = np.random.rand(1000)

    # normal distribution
    #t1 = np.random.normal(size=1000)
    #t2 = np.random.normal(size=1000)

    # gamma distribution
    #t1 = np.random.gamma(1,1,size=1000)
    t2 = np.random.gamma(1,1,size=1000)

    # calculate correlation & p-value
    corr, pvalue = pearsonr(t1,t2)
    
    # add to lists
    correlations.append(round(corr,4))
    pvalues.append(round(pvalue,4))
    #print(correlations)
    #print(pvalues)

# plot
print("\n -- CORRELATIONS --")
print("avg : {}\nmin : {}\nmax : {}".format(np.mean(correlations), min(correlations), max(correlations)))
print("2,5% : {}\n5% : {}\n10% : {}".format(np.percentile(correlations, 2.5),np.percentile(correlations, 5),np.percentile(correlations, 10)))
print("90% : {}\n95% : {}\n97.5% : {}".format(np.percentile(correlations, 90),np.percentile(correlations, 95),np.percentile(correlations, 97.5)))
sns.distplot(correlations)
plt.show()

print("\n -- P-VALUES --")
print("avg : {}\nmin : {}\nmax : {}".format(np.mean(pvalues), min(pvalues), max(pvalues)))
sns.distplot(pvalues)
plt.show()



"""
import matplotlib.pyplot as plt; plt.rcdefaults()

 
 
plt.bar(y_pos, performance, align='center', alpha=0.5)
plt.xticks(y_pos, objects)
plt.ylabel('Usage')
plt.title('Programming language usage')
 
plt.show()
"""




















