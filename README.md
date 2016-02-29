# Economic scenarios for credit risk #
This project aims at forecasting economic scenarios for the credit risk. 
It is motivated by the IFRS 9 reglamentation. 

## Introduction ##
An economic scenario is defined by the time series of a set of economic variables.
In the context of the credit risk modelling, some of the relevant macroeconomic variables are:
* GDP <br />
* Unemployment <br />
* Interest rate <br />
* Housing price index <br />

For forecasting, it is important for the models to be causal, which implies bounded prediction errors.
Stationarity is often assumed when fitting a time series model, which means that the forecast converges to an asymptotic mean value. Hence, for richer long-term predictions, one can incorporate opinions from experts, namely, adding a time-dependent mean function.


## Modelling ##

### AR(1) ###
The simplest interest rate model is the Vasicek model (an [Ornstein–Uhlenbeck process] (https://en.wikipedia.org/wiki/Ornstein%E2%80%93Uhlenbeck_process)).
The discretization of the stochastic differential equation corresponds to a first order autoregression model, i.e. AR(1). 
When a time-dependent mean value is considered, the model is called Hull-White. 
See **interestRate.R**, where the European short-term interest rate (or Euribor) is studied. 

### VAR(1) ###
A VAR(1) model is fitted using the **vars** package, to the available historical time series for the variables: GDP, unemployment and interest rate, for Portugal. It is done in **varPT.R**, where I also use my own Monte Carlo sampling function to simulate the future evolution. However, this differs from the result from the **predict** function in **vars**. 

The fit suggests that the interest rate depends very little on the other variables, hence, we can think of it being a cause. This can be justified as interest rates reacting earlier to the recession. 


## Discussion ##

There are ways to improve the model. The idea is to think of recession as an external drive, and the other variables reacting to it. The advantadge of this approach is that we only need to input recession (e.g. from experts' opinions), and the dependencies of the other variables to it will come from the historical data.

For example, we can consider recession as a binary variable, i.e. 1 when it happens, and 0 otherwise. To fit the parameters using historical data, we can use a variable as a proxy to it. In our simple approach, the interest rate actually plays such role. Another proxy can be the US unemployment rate, since it responds quite cleanly to recessions. 

Note that I didn't add housing price index into my VAR(1) model. That is due to the lack of quartely data of it (I have only yearly data). We can study its dependence with the yearly time series of the other variables by, e.g., the least squared error method, as it is how was done in the **vars** package for each equation in the VAR(1) model. 

Higher order models can also be used, but I think this doesn't improve much the long-term forecast anyways, so don't overfit the data and keep the structual dependecies simple. 





## References ##
* https://onlinecourses.science.psu.edu/stat510 <br />
* http://www.bportugal.pt/Mobile/BPStat/DominiosEstatisticos.aspx <br />
* https://data.oecd.org <br />
* An example of [a long-term forward economic scenario] (http://www.oecd.org/officialdocuments/publicdisplaydocumentpdf/?cote=ECO/WKP(2012)77&docLanguage=En), from OECD.


# Acknoweledgement #
This project started at Deloitte Portugal, Lisbon.
I would like to thank Filipe Correia for his supervision, 
and the GATIS network for the financial support.
