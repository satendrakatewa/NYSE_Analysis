# NYSE_Analysis


Problem Statement:

 

A comprehensive U.S. stock market dataset containing company fundamentals, daily stock prices, and sector classifications will be analyzed to generate deep financial insights for portfolio management, sector analysis, valuation modeling, and stock performance forecasting. The goal is to evaluate company health, price volatility, sector-wise trends, and valuation metrics, while also building predictive models for adjusted price forecasting and revenue projections to support investment decision-making.

Dataset Link: NY Stock

Part 1: SQL Analysis (12 Questions Based on Your Dataset)

1. Calculate the average net income per year for each ticker symbol and identify the top 3 companies with the highest average net income.
2. Find the year-over-year growth percentage of total revenue for a specific company (ticker_symbol = 'AAL') for the years available in the data.
3. Identify the companies and years where the profit margin was negative, and list those records along with the net income and total revenue.
4. For each company, compute the average quick ratio over all years and find companies with an average quick ratio below 1, indicating potential liquidity issues.
5. Using window functions, find the 3-year rolling average of research and development expenses (research_and_development) for each company.
6. Find companies where the capital expenditures have increased consecutively for at least 3 years.
7. List the top 5 years (period_ending) with the highest total liabilities summed over all companies.
8. For each company, find the year with the maximum net cash flow from operating activities (net_cash_flow_operating).
9. Find the average earnings per share (EPS) for companies where the total equity exceeds 5 billion and the operating margin is greater than 10%.
10. Determine the correlation (using MySQL approximate calculation) between research and development expenses and net income for a selected company (ticker_symbol = 'AAL').

    Part 2: Power BI / Tableau Dashboard
Page 1: Executive Market Overview
Total Companies Analyzed
 
Average Net Income
 
Monthly Stock Volume Trend
 
MoM Growth in Adjusted Prices
 
Page 2: Financial Insights
Top 10 Companies by Net Income
 
YoY Revenue Growth Chart
 
ROE vs Net Margin
 
Debt/Equity Ratio by Sector
 
P/E Ratio Trends
 
Page 3: Price & Trading Performance
Monthly Adjusted Closing Price Trends
 
Volatility Score (std dev of close price)
 
Trading Volume Trends
 
Top 10 Most Stable Stocks
 
Price Change
 

Page 4: Sector Analytics
Sector-wise Avg. Net Income
 
Revenue Trends by Sector
 
Top 5 Sectors by Profit Margin
 
Sector-Wise Debt Burden
 
Bubble chart: Market Cap vs Profitability
 
Page 5: Valuation Metrics
Value vs Growth Stock Distribution
 
Sector-wise Dividend Yield (if present)
 
High PE / Low PE stocks
 
PEG Ratio trends (if possible)
 
Valuation Map



Part 3: Python (EDA + Forecasting & Trend Analysis)
Tasks:
 

1. EDA on:
 

Adjusted stock prices
 
Financial metrics over years
 
Sector-wise patterns
 
2. Time-Series Dataset Creation

Monthly average adjusted closing prices
 
Monthly revenue (using fundamentals)
 

3. Trend & Seasonality

Use statsmodels or Prophet to detect seasonality in adjusted close prices
 
Forecast next 12 months of adjusted price for top 5 companies
 
 

4. Category-Level Forecasting
 

Revenue forecast by GICS Sector
 
 

5. Visualizations

Line plots, trend lines, rolling averages
 
Sector heatmaps of predicted growth
