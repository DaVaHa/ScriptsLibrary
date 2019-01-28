'''

Tricks on Python Library : NUMPY

'''

import numpy as np


## GENERATE RANDOM NUMBERS ##
#https://docs.scipy.org/doc/numpy-1.13.0/reference/routines.random.html

# random integers
# including low, excluding high
np.random.randint(low=0,high=10,size=10)  # = numpy.ndarray

# random sample from 'standard normal' distribution
# mean = 0 & variance = 1
np.random.randn() # = float
np.random.randn(2,4) # = numpy.ndarray of shape (2,4)
