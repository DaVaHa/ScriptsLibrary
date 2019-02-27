'''

PYTHON LIBRARY : matplotlib

'''

# visualize linear relationship
import matplotlib.pyplot as plt

## black round points & red model line
fig, axis = plt.subplots() # Create figure and axis objects and call axis.plot() twice to plot data and model distances versus times
axis.plot(times, measured_distances, linestyle=" ", marker="o", color="black", label="Measured")
axis.plot(times, model_distances, linestyle="-", marker=None, color="red", label="Modeled")
axis.grid(True)
axis.legend(loc="best")
plt.show()

# dashed line , square markers
fig, axis = plt.subplots() # Create figure and axis objects using subplots()
axis.plot(x, y, color="green", linestyle="--", marker="s")
plt.show()
axis.plot(times , distances , linestyle=" ", marker="o", color="red") # red round points, no line


