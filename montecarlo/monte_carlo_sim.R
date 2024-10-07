

#moving onto Monte Carlo simulation with basis of our transition matrix

#single price path
simulate_price_path <- function(initial_price, initial_state, transition_matrix, n_days, up_pct = 0.01, down_pct = 0.01){
  price <- initial_price
  state <- initial_state
  price_path<- numeric(n_days)
  price_path[1] <- price

  #state names
  states<- rownames(transition_matrix)

  for(day in 2:n_days){

    #next state based on current (respective probs)
    next_state <- sample(states, 1, prob = transition_matrix[state,])

    #adjust price
    if(next_state == "Up"){
      price <- price* (1 + up_pct)

    }
    else if(next_state == "Down") {
      price <- price * (1-down_pct)

    }
    #updated price
    price_path[day] <- price
    #update state
    state <- next_state
  }
  return(price_path)
}

#Example simulation


initial_price <- tail(price_data$Price,1)
initial_state <- tail(price_data$State, 1)
n_days <- 365

simulated_path <- simulate_price_path(initial_price, initial_state, transition_matrix, n_days)

simulated_path




#now this will run for multiple simulations not only one
run_monte_carlo<- function(initial_price, initial_state, transition_matrix, n_days, n_simulations, up_pct = 0.01, down_pct = 0.01){

  #stores all
  all_sim <- matrix(NA, nrow = n_days, ncol = n_simulations)


  #run
  for(i in 1:n_simulations){
    all_sim[, i]<- simulate_price_path(initial_price, initial_state, transition_matrix, n_days, up_pct, down_pct)
  }

  return(all_sim)

}


#example run (1000)

n_simulations <- 1000
all_sim <- run_monte_carlo(initial_price, initial_state, transition_matrix, n_days, n_simulations)

head(all_sim)


simulated_df <- as.data.frame(all_sim)


#for plotting
simulated_df$Day <- 1:n_days


simulated_long <- melt(simulated_df, id = "Day")

#plot first 10 paths

ggplot(simulated_long[simulated_long$variable %in% paste0("V", 1:10),], aes(x = Day, y = value, color=variable)) + geom_line() +
  labs(title = "Monte Carlo of stock prices", x = "Days", y = "Simulated Stock Price") +
  theme_minimal()


#As we can see, as Monte Carlo is Stochastic statistics this data itself doesn't help us make conclusions especially with a sample of 10 paths, let's do more


summary_stats<- data.frame(Day = 1:n_days,Mean=apply(all_sim,1,mean),
                           Median=apply(all_sim,1,median),
                           Lower95=apply(all_sim, 1,quantile, probs=0.025),
                           Upper95=apply(all_sim,1,quantile,probs=0.975))


#now plot mean and confint

ggplot(summary_stats, aes(x = Day)) +
  geom_line(aes(y=Mean), color = "blue")+
  geom_ribbon(aes(ymin=Lower95, ymax=Upper95), alpha=0.2) +
  labs(title = "Simulated Stock Price with 95% Confidence Interval", x = "Days", y = "Stock Price") +
  theme_minimal()
