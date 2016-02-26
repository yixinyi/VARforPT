source("sampling.R")

# Monthly data, of length 265
interest <- read.csv("shortInterestRateEU.csv", header = TRUE)
colnames(interest) <- c("Date", "InterestRate")

# Split the data into 2 sets, decided by studying the histogram (done in Mathematica)
beforeCrisis <- interest[1:180, ]
afterCrisis  <- interest[181:265, ] # starts with 2009-01

# Vasicek model and sampling
forecastInterestRate <- function(data, n, horizon) {
  # Find the Vasicek parameters with the assumption of 1 unit time step
  v <- vasicekParameters(data)
  
  # Parameters for the Monte Carlo sampling
  dt    <- 1 
  alpha <- v[["alpha"]] / dt
  sigma <- v[["sigma"]] / sqrt(dt)
  
  # Here we assumed 2 regimes for mu: 1 from Vasicek, and a linear behavior, after a time tau
  mu    <- function(t) { 
    tau <- 12 * 5 
    if (t < tau) v[["mu"]] / dt 
    else         v[["mu"]] / dt + 0.004 * (t - tau)
  }
  v0    <- tail(data, n = 1) 
  samplingOU(n, dt, horizon, alpha, mu, sigma, v0)
}


# Plot the results from the simulation  
interestRatePlot <- function(data, n, horizon, nameX,  nameY) {
  len <- length(data)
  plot(
    c(1:len), data, 
    xlim = c(0, len + horizon), #ylim = c(-2, 8),
    xlab = nameX, ylab = nameY
  )
  ans <- forecastInterestRate(data, n, horizon)
  lines(ans[, 1] + len, ans[, 2], pch = 20)
  lines(ans[, 1] + len, ans[, 2] + ans[, 3] , col = "red")
  lines(ans[, 1] + len, ans[, 2] - ans[, 3] , col = "red")
}


# Plot the full data set
# plot(interest$Date, interest$InterestRate)

# Parameters for the sampling
n       <- 100
horizon <- 120 * 2

# To combine plots. Defined for 1 below.
par(mfrow=c(1,1))

# Study the interest rate after the 2008 crisis
data1  <- afterCrisis[, 2]
interestRatePlot(data1, n, horizon, "time (months)", "EU short-rate, 2009-2015")
print(vasicekParameters(data1))

# Log-Vasicek for the data before crisis
# We can use forecastInterestRate, but the mu defined now is for afterCrisis
# data2 <- log(beforeCrisis[, 2]) 
# interestRatePlot(data2, n, horizon, "time (months)", "log of EU short-rate, 1994-2008")
# print(vasicekParameters(data2))
