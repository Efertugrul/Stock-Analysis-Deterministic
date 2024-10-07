#Data processing
library(quantmod)
library(ggplot2)
library(reshape2)
#from Yahoo take an example stock
getSymbols("AAPL", src = "yahoo", from = "2015-01-01", to = "2020-01-01")
prices <- Cl(AAPL)
head(prices)



#compared to previous day
returns <- dailyReturn(prices)

#threshold to determine significance
limit <- 0.01

#categorize by quality
states <- ifelse(returns > limit, "Up", ifelse(returns < -limit,
                                               "Down", "Stable"))

#add it to df

price_data  <- data.frame(Date = index(prices), Price = coredata(prices), Returns = returns, State = states)

#now all in one
colnames(price_data)[c(2,3,4)] <- c("Price", "Returns", "State")
head(price_data)
