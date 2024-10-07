#Finally let's try GARCH modeling to test for varying variances
library(rugarch)

# Specify GARCH(1,1) model
garch_spec <- ugarchspec(variance.model = list(garchOrder = c(1, 1)),
                         mean.model = list(armaOrder = c(1, 0)))

# Fit GARCH model to stock returns
garch_fit <- ugarchfit(spec = garch_spec, data = returns)

# Simulate future returns with GARCH model
garch_sim <- ugarchsim(garch_fit, n.sim = n_days, m.sim = n_simulations)

# Extract simulated prices
simulated_returns <- fitted(garch_sim)
# Make sure garch_price_paths is a matrix with columns for each simulation
garch_price_paths <- matrix(garch_price_paths, nrow = n_days, ncol = n_simulations)

# Convert the price paths matrix into a data frame
garch_simulated_df <- as.data.frame(garch_price_paths)
garch_simulated_df$Day <- 1:n_days  # Add the Day column for plotting

# Reshape the data for ggplot, treating each column as a separate simulation (V1, V2, ..., Vn)
library(reshape2)
garch_long <- melt(garch_simulated_df, id = "Day")

# Check the reshaped data (this should now contain variables like V1, V2, etc.)

# Plot the first 10 GARCH-simulated paths
ggplot(garch_long[garch_long$variable %in% paste0("V", 1:10),], aes(x = Day, y = value, color = variable)) +
  geom_line() +
  labs(title = "GARCH-Simulated Stock Price Paths", x = "Days", y = "Simulated Stock Price") +
  theme_minimal()

#volatility check from GARCH(common)


sim_volatility<- sigma(garch_sim)

volatility_df <- as.data.frame(sim_volatility)

volatility_df$Day <- 1:n_days


#reshape

volatility_long <- melt(volatility_df, id = "Day")


#plot
ggplot(volatility_long[volatility_long$variable %in% paste0("V", 1:10),], aes(x = Day, y = value, color = variable)) +
  geom_line() +
  labs(title = "GARCH-Simulated Volatility Paths", x = "Days", y = "Simulated Volatility") +
  theme_minimal()
