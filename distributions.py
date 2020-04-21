"""

Distributions

"""

import numpy as np
import matplotlib.pyplot as plt

# Subplots

# Square Root : x
plt.subplot(321)
x = np.array([i for i in range(30)])
y = np.array([i for i in range(30)])
plt.scatter(x, y)
plt.title("Distribution : y = x")
#plt.show()


# Square Root : x ** 0.5
plt.subplot(322)
sqrt_x = np.array([i for i in range(30)])
sqrt_y = np.array([i ** 0.5 for i in range(30)])
plt.scatter(sqrt_x, sqrt_y)
plt.title("Distribution : y = x ** 0.5")
#plt.show()

# Squared : x ** 2
plt.subplot(323)
sqrd_x = np.array([i for i in range(30)])
sqrd_y = np.array([i ** 2 for i in range(30)])
plt.scatter(sqrd_x, sqrd_y)
plt.title("Distribution : y = x ** 2")
#plt.show()


# Natural Logaritm : np.e
plt.subplot(324)
log_x = np.array([i for i in range(30)])
log_y = np.array([np.log(i) for i in range(30)])
plt.scatter(log_x, log_y)
plt.title("Distribution : y = [e]log(x)")
#plt.show()


# Logaritm : np.log10
plt.subplot(325)
log10_x = np.array([i for i in range(30)])
log10_y = np.array([np.log10(i) for i in range(30)])
plt.scatter(log10_x, log10_y)
plt.title("Distribution : y = [10]log(x)")
#plt.show()

# Exponential : np.e
plt.subplot(326)
exp_x = np.array([i for i in range(30)])
exp_y = np.array([np.exp(i) for i in range(30)])
plt.scatter(exp_x, exp_y)
plt.title("Distribution : y = exp(x)")
plt.show()


