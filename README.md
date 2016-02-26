# Economic scenarios for credit risk #
This project aims at forecasting economic scenarios for credit risk. 
It is motivated by the IFRS 9 reglamentation. 

# Introduction #
An economic scenario is defined by the time series of a set of economic variables.
In the context of the credit risk modelling, some of the relevant macroeconomic variables are:
* GDP <br />
* Unemployment <br />
* Interest rate <br />
* Housing price index <br />

# Methods #
The simplest interest rate model is the Vasicek model. 
Its Euler discretization corresponds to a first order autoregressive model. 

/n

For forecasting, it is important for the models to be causal, which implies bounded prediction errors.
Stationary models converge to a mean value, hence, for long-term predictions, one must incorporate opinions from experts.


# Model #
A VAR(1) model is fitted to the available historical time series for the variables (GDP, unemployment, interest rate). 
This helps to see the structural dependency of them.
/n

There are ways to improve this simplistic approach.
Since we are interested in a limited number of variables in the Portuguese economy, 
we can have recession as an external drive, and the other variables reacting to it.



# References #
* https://onlinecourses.science.psu.edu/stat510 <br />


# Acknoweledgement #
This project started at Deloitte Portugal, Lisbon.
I would like to thank Filipe Correia for his supervision, 
and the GATIS network for the financial support.
