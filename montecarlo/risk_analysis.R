#now that we have metrics well annotated and ready,let's move on to Value at Risk calculation (Of course all this had a purpose)

#final day prices from all sims

final_prices<- all_sim[n_days, ]


#VaR
VaR_95 <- quantile(final_prices, probs = 0.05)
VaR_95


#Now more in depth, looking at conditioanal VaR

CVaR_prices <- final_prices[final_prices < VaR_95]

#calculate CVaR as avg

CVaR_95<- mean(CVaR_prices)
CVaR_95


#Not done yet, now calculate Maximum Drawdown which is essentially worst case decline from peak
max_drawdown_fun <- function(price_path){
  peak <- max(price_path)
  trough<- min(price_path[which(price_path == peak): length(price_path)])

  max_drawdown<- (peak- trough) / peak
  return(max_drawdown)

}


#apply to all

max_dds<- apply(all_sim,2, max_drawdown_fun)

#calculate avg and worst case dd
avg_max_dd <- mean(max_dds)
worst_case <- max(max_dds)


avg_max_dd
worst_case


#plot the dist

ggplot(data.frame(Price= final_prices), aes(x = Price))+
  geom_histogram(bins = 30, fill= "blue", alpha = 0.7)+
  geom_vline(xintercept = VaR_95, color = "red", linetype = "dashed", size = 1.5)+
  geom_vline(xintercept = CVaR_95, color = "orange", linetype = "dashed", size = 1.5) +
  labs(title = "Distribution of Simulated Final Prices", x = "Final Stock Price",
       y = "Frequency") +
  theme_minimal() +
  annotate("text", x=VaR_95, y = max(hist(final_prices, plot = FALSE)$counts),
           label = paste("VaR (95%):", round(VaR_95, 2)), hjust = 1.5, color = "red") +
  annotate("text", x = CVaR_95, y = max(hist(final_prices, plot = FALSE)$counts),
           label = paste("CVaR (95%):", round(CVaR_95, 2)), hjust = -0.5, color = "orange")

#let's check for sensitivity analysis for different percentages
sens_analysis <- function(up_pct_vals, down_pct_vals, n_simulations, n_days){
  results <- data.frame()

  for(up in up_pct_vals){
    for(down in down_pct_vals){

      #run sim
      sim <- run_monte_carlo(initial_price, initial_state, transition_matrix, n_days, n_simulations, up, down)


      #calculate VaR
      final <-sim[n_days, ]
      VaR_95 <- quantile(final, probs = 0.05)
      CVaR_95<- mean(final[final < VaR_95])

      #store
      results <- rbind(results, data.frame(up, down, VaR_95, CVaR_95))
    }
  }
  return(results)
}



#analysis
up_pct_vals <- c(0.01,0.02,0.05)
down_pct_vals<- c(0.01,0.02,0.05)
sens_res<- sens_analysis(up_pct_vals, down_pct_vals, n_simulations,n_days)
sens_res
#This provides great info!

#Now let's do stress testing to understand prices react to extreme conditions

#We modify tr matrix to increase probability of "Down"

stress_trans_matrix <- transition_matrix
stress_trans_matrix["Up", "Down"] <- 0.4
stress_trans_matrix["Down", "Down"] <- 0.7
stress_trans_matrix<- prop.table(stress_trans_matrix,1) #normalize

stress_sims <- run_monte_carlo(initial_price, initial_state, stress_trans_matrix, n_days, n_simulations, up_pct = 0.01, down_pct = 0.1)


#calculate value at risk and conditioned var

final_prices_stress<- stress_sims[n_days, ]
var_95_stress<- quantile(final_prices_stress, probs=0.05)

cvar_95_stress <- mean(final_prices_stress[final_prices_stress < var_95_stress])

var_95_stress
cvar_95_stress
