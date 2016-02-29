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
Stationary models converge to their mean value asymptotically, hence, for richer long-term predictions, one must incorporate opinions from experts.

## Modelling ##

### AR(1) ###
The simplest interest rate model is the Vasicek model (an [Ornstein–Uhlenbeck process] (https://en.wikipedia.org/wiki/Ornstein%E2%80%93Uhlenbeck_process)).
The discretization of the stochastic differenctial equation corresponds to a first order autoregression model, i.e. AR(1). 
When a time-dependent mean value is considered, the model is called Hull-White. 
See **interestRate.R**, where the European short-term interest rate (or Euribor) is used.



### VAR(1) ###
A VAR(1) model is fitted using the **vars** package, to the available historical time series for the variables: GDP, unemployment and interest rate, for Portugal. It is done in **varPT.R**, where I also use my own Monte Carlo sampling function to simulate the future evolution. However, this differs from the result from the **predict** function in **vars**. 


## What to do next ##

There are ways to improve this simplistic approach.
Since we are interested in a limited number of variables in a particular country (Portugal in our case), 
we can think of recession as an external drive, and the other variables reacting to it.
One way to do it is to have recession as a binary variable, i.e. 1 when it happens, and 0 otherwise.
We can also use a variable as a proxy to it. In our simple approach, the interest rate actually plays such role.
Another proxy can be the US unemployment rate, since one can read the recessions easily from it.



## References ##
* https://onlinecourses.science.psu.edu/stat510 <br />
* http://www.bportugal.pt/Mobile/BPStat/DominiosEstatisticos.aspx <br />


# Acknoweledgement #
This project started at Deloitte Portugal, Lisbon.
I would like to thank Filipe Correia for his supervision, 
and the GATIS network for the financial support.
