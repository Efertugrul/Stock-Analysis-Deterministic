
library(quantmod)
library(ggplot2)
library(reshape2)

#naturally we need the transition matrix now for Markov chain
price_data$NextState <- c(price_data$State[-1], NA)
#last row gone
price_data <- na.omit(price_data)


#freq  table
transition_count <- table(price_data$State, price_data$NextState)
#transition matrix rows adding up to one as per probability requirements
transition_matrix <- prop.table(transition_count, 1)
transition_matrix

#verify
sums <- rowSums(transition_matrix)
all(sums == 1)


#quick visuals for the matrix
transition_df <- melt(transition_matrix)


#heatmap best fit
ggplot(transition_df, aes(Var1, Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "blue") +
  labs(x = "Current State", y = "Next State", fill = "Probability") +
  theme_minimal()


