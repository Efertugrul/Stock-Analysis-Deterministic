
# **Stock Price Simulation Using Markov Chains and GARCH Models**

## **Overview**
This project simulates future stock price movements using a combination of **Markov chains**, **Monte Carlo simulations**, and **GARCH models** to capture time-varying volatility. We evaluate potential price paths and perform risk analysis using metrics such as Value at Risk (VaR) and Conditional VaR (CVaR).

## **Table of Contents**
- [Project Structure](#project-structure)
- [Installation](#installation)
- [Usage](#usage)
- [Results](#results)
- [Risk Analysis](#risk-analysis)
- [Contributions](#contributions)
- [License](#license)

---

## **Project Structure**
The project is organized as follows:
- **`scripts/`**: Contains R scripts for each part of the analysis (Markov chains, Monte Carlo, GARCH, risk analysis).
- **`report/`**: Includes the final research report summarizing the project.
- **`images/`**: Stores the visualizations (price paths, risk metrics).
- **`README.md`**: This file, which gives an overview of the project and usage instructions.

---

## **Installation**
To run the project, you'll need the following R libraries:
```r
install.packages(c("quantmod", "markovchain", "rugarch", "ggplot2", "PerformanceAnalytics"))
```
Ensure all scripts are sourced in order, or run the `main.R` file for a full end-to-end simulation.

---

## **Usage**
You can run the project with the `main.R` script, which executes the following steps:
1. **Data Processing**: Fetch stock data (e.g., AAPL) and calculate returns.
2. **Markov Chain**: Create a transition matrix representing stock price changes.
3. **Monte Carlo Simulation**: Simulate multiple stock price paths.
4. **GARCH Model**: Add time-varying volatility with the GARCH model.
5. **Risk Analysis**: Calculate VaR, CVaR, and maximum drawdown.

### **Example Commands**:
```r
source("main.R")
```

---

## **Results**
### **Simulated Stock Price Paths**
Here are example results from the Monte Carlo and GARCH simulations. These paths represent potential future stock prices for a period of 365 days.

![Simulated Stock Price Paths](/montecarlo/img/plot1.png)

---

## **Risk Analysis**
The project also calculates key risk metrics:
- **Value at Risk (VaR)**: The worst expected loss over a given period, at a 95% confidence level.
- **Conditional VaR (CVaR)**: The average loss in the worst 5% of cases.

Example results for risk metrics:

![VaR and CVaR](/montecarlo/img/plot2.png)

---

## **Confidence Interval**
A plot showing the stock price simulation with a 95% confidence interval over 365 days:

![Simulated Stock Price with 95% Confidence Interval](/montecarlo/img/plot3.png)

---

## **Transition Matrix**
This heatmap visualizes the transition probabilities between stock price movement states (Up, Down, Stable).

![Transition Matrix Heatmap](/montecarlo/img/plot4.png)

---

## **GARCH-Simulated Volatility**
This plot shows the volatility paths simulated using the GARCH(1,1) model over 365 days.

![GARCH-Simulated Volatility Paths](/montecarlo/img/plot5.png)

---

## **Contributions**
Feel free to fork this project, submit issues, or contribute by making pull requests. All contributions are welcome.

---

## **License**
This project is licensed under the Apache License - see the LICENSE file for details.

