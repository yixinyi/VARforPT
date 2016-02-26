library("vars")
source("sampling.R")

dataFull <- read.csv("portugalQ.csv", header = TRUE)
colnames(dataFull) <- c("Date", "GDP", "Unemployment", "InterestRate")

# Fit VAR using vars package
data  <- dataFull[, 2:length(dataFull)] # remove the years
adf1  <- summary(ur.df(data[, 1], type = "trend", lags = 2))
var   <- VARselect(data, lag.max = 8, type = "both")
p1ct  <- VAR(data, p = 1, type = "both")
pred1 <- predict(p1ct, n.ahead = 20)
print(summary(p1ct))
fanchart(pred1)


# Simulating the forecast using the coefficients given by VAR function, for lag 1 only
# See if it's possible to extract the coefficients directly from pred1
v0      <- c(1.4, 11.9, -0.027)  # tail(data, n = 1) need to convert it to vector
a       <- rbind(c(0.89, 0.03, -0.3), c(-0.13, 0.86, -0.03), c(0.08, 0.02, 0.92))
trend   <- function(t) { c(1.5, 0.9, 0) + c(-0.03,  0.013, -0.002) * t }
sigma   <- rbind(c(1, -0.2, 0.1), c(-0.2,  0.3, -0.02), c(0.1, -0.02, 0.1))
horizon <- 4 * 10
ans     <- samplingVAR(100, horizon, a, trend, sigma, v0)

ans1 <- cbind(ans[,1], ans[,2], ans[,5])
ans2 <- cbind(ans[,1], ans[,3], ans[,6])
ans3 <- cbind(ans[,1], ans[,4], ans[,7])
# Combine plot in 3 rows
par(mfrow=c(3,1))
samplingPlot(ans1, "GDP")
samplingPlot(ans2, "Unemployment")
samplingPlot(ans3, "Interest rate")

