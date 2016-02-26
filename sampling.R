# Copyright (c) 2016 Xinyi Chen Lin, under the MIT License: https://opensource.org/licenses/MIT
# It contains sampling and fitting functions to study autoregressive models of 1 lag.
# List of functions:
#     samplingVAR
#     samplingAR
#     samplingOU
#     samplingPlot
#     linearFit
#     linearFitPlot
#     vasicekParameters
#     mmse
#     estimatorL1



# Simulate a VAR(1) process, with a trend that is a function of time
samplingVAR <- function(n, time, a, trend, sigma, v0) {
  # number of variables
  len    <- length(v0)
  # Initial values
  t      <- 1
  v      <- matrix( rep(v0, n), len) # len x n
  # Initialize time series
  timeTS <- c()
  meanTS <- c()
  sdTS   <- c()
  while (t < time) {
    # mvrnorm gives n x len matrix, so error is len x n
    error = t(mvrnorm(n, rep(0, len), sigma)) 
    # apply a (size len x len) to v (size len x n) can also be achieved using apply(t(a), 2, "%*%", v)
    v = a %*% v + trend(t) + error
    
    meanTS = rbind(meanTS, rowMeans(v))
    sdTS   = rbind(sdTS, apply(v, 1, sd))
    timeTS = append(timeTS, t)
    t = t + 1
  }  
  ans <- cbind(timeTS, meanTS, sdTS)
  return(ans)
}


# Simulate an AR(1) process, with no time-dependent trends
samplingAR <- function(n, time, a, const, sigma, v0) {
  t <- 1
  v <- v0
  matrix <- c()
  while (t < time) {
    v  = a * v + const + sigma * rnorm(n, mean = 0, sd = 1) 
    matrix = cbind(
      append(matrix[, 1], t),
      append(matrix[, 2], mean(v)),
      append(matrix[, 3], sd(v))
    )
    t = t + 1
  }  
  colnames(matrix) <- c("time", "mean", "sd")
  return(matrix)
}


# Ornstein–Uhlenbeck process, where mu is a function of time
# It is Vasicek when mu is constant, and Hull-White, when it's time-dependent.
samplingOU <- function(n, dt, time, alpha, mu, sigma, v0) {
  t <- dt
  v <- v0
  matrix <- c()
  while (t < time) {
    v  = v + alpha * (mu(t) - v) * dt + sigma * sqrt(dt) * rnorm(n, mean = 0, sd = 1) 
    matrix = cbind(
      append(matrix[, 1], t),
      append(matrix[, 2], mean(v)),
      append(matrix[, 3], sd(v))
    )
    t = t + dt
  }  
  colnames(matrix) <- c("time", "mean", "sd")
  return(matrix)
}


# This function plots the expected value and the standard deviation in the same plot
# The input must have be a matrix with columns (time variable, mean, sd).
samplingPlot <- function(sampling, nameY){
  ans <- sampling
  plot(ans[, 1], ans[, 2], pch = 20, xlab = "time", ylab = nameY)
  lines(ans[, 1], ans[, 2] + ans[, 3] , col = "red")
  lines(ans[, 1], ans[, 2] - ans[, 3] , col = "red")
}


# Linear regression for the variable and its first lag
linearFit <- function(data){
  len  <- length(data)
  lag0 <- data[1:len-1]
  lag1 <- data[2:len]
  lm(lag1 ~ lag0)
}

# This function calls linearFit to plot the fit and the original data
linearFitPlot <- function(data, nameX, nameY){
  fit  <- linearFit(data)
  x    <- fit$model[[1]]
  y    <- fit$model[[2]]
  plot(
    x, y,
    xlab = nameX, ylab = nameY
  )
  abline(fit, col = "red")
}

# Convert the coefficients from the linearFit function to Vasicek parameters
vasicekParameters <- function(data){
  # Fit the coefficients
  fit       <- linearFit(data)
  intercept <- fit$coefficients[[1]]
  slope     <- fit$coefficients[[2]]
  
  # Note that we use unit time step!
  # reversion rate
  alpha <- (1 - slope)
  # mean
  mu    <- intercept / alpha
  # standard deviation of the residuals
  sigma <- sd(residuals(fit))
  
  ans        <- c(alpha, mu, sigma)
  names(ans) <- c("alpha", "mu", "sigma")
  return(ans)
}


# Minimal mean square error for 1 variable, alternative to linearFit
mmse <- function(estimator, par0, dat) {
  mse <- function(par, y){
    n   <- length(y)
    error     <- y[2:n] - estimator(par, y)
    (t(error) %*% error)/n
  }
  nlminb(start = par0, obj = mse, y = dat)
}

# Linear estimator of lag 1, to be used as an input of mmse
estimatorL1 <- function(par, y){
  n <- length(y)
  par[1] + par[2] * y[1:(n-1)]
} 

