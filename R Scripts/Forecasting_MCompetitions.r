# Forecasting : M- Competitions
# R package MComp
# Documentation : https://cran.r-project.org/web/packages/Mcomp/Mcomp.pdf

# M1
# plot(M1$YAF2)
# subset(M1,"monthly")

# M3
# plot(M3[[32]])
# subset(M3,"monthly")

library("forecast")
library("Mcomp")


# Try methods for Yearly time series
subset(M3,"yearly")
M3
