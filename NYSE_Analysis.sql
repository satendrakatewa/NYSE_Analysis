# 1.Calculate the average net income per year for each ticker symbol 
# and identify the top 3 companies with the highest average net income.

SELECT
    Ticker_symbol,
    YEAR(period_ending) AS year,
    AVG(net_income) AS average_net_income
FROM fundamentals
WHERE net_income IS NOT NULL
GROUP BY Ticker_symbol, YEAR(period_ending)
ORDER BY average_net_income DESC
LIMIT 3;













# 2. Find the year-over-year growth percentage of total revenue for a specific
# company (ticker_symbol = 'AAL') for the years available in the data.


WITH revenue_by_year AS (
    SELECT
        YEAR(period_ending) AS `Year`,
        SUM(total_revenue) AS `Total_Revenue`
    FROM fundamentals
    WHERE ticker_symbol = 'AAL' AND total_revenue IS NOT NULL
    GROUP BY YEAR(period_ending)
)
SELECT
    `Year`,
    `Total_Revenue`,
    ROUND(
        (Total_Revenue - LAG(Total_Revenue) OVER (ORDER BY `Year`)) / LAG(Total_Revenue) OVER (ORDER BY `Year`) * 100,
        2
    ) AS `YoY_Growth_Percent`
FROM revenue_by_year
ORDER BY `Year`;











# 3. Identify the companies and years where the profit margin was negative,
# and list those records along with the net income and total revenue.

SELECT
    Ticker_symbol AS `Ticker Symbol`,
    YEAR(period_ending) AS `Year`,
    net_income AS `Net Income`,
    total_revenue AS `Total Revenue`,
    ROUND((net_income / total_revenue) * 100, 2) AS `Profit Margin (%%)`
FROM fundamentals
WHERE 
    net_income IS NOT NULL
    AND total_revenue IS NOT NULL
    AND total_revenue != 0
    AND (net_income / total_revenue) < 0
ORDER BY `Profit Margin (%%)` ASC;














# 4. For each company, compute the average quick ratio over all years and find
# companies with an average quick ratio below 1, indicating potential liquidity issues.

SELECT 
    Ticker_symbol AS `Ticker Symbol`,
    ROUND(AVG(quick_ratio), 2) AS `Average Quick Ratio`
FROM fundamentals
WHERE quick_ratio IS NOT NULL
GROUP BY `Ticker Symbol`
HAVING `Average Quick Ratio` < 1
ORDER BY `Average Quick Ratio` ASC;
















# 5. Using window functions, find the 3-year rolling average of research
# and development expenses (research_and_development) for each company.

SELECT 
    Ticker_symbol AS `Ticker Symbol`,
    YEAR(period_ending) AS `Year`,
    research_and_development AS `R&D Expense`,
    ROUND(
        AVG(research_and_development) OVER (
            PARTITION BY Ticker_symbol 
            ORDER BY YEAR(period_ending) 
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ), 2
    ) AS `3-Year Rolling Avg R&D`
FROM fundamentals
WHERE research_and_development IS NOT NULL
ORDER BY `Ticker Symbol`, `Year`;


















# 6. Find companies where the capital expenditures have increased consecutively for at least 3 years.

WITH capex_with_lag AS (
    SELECT 
        Ticker_symbol,
        YEAR(period_ending) AS year,
        capital_expenditures,
        LAG(capital_expenditures, 1) OVER (PARTITION BY Ticker_symbol ORDER BY YEAR(period_ending)) AS prev1,
        LAG(capital_expenditures, 2) OVER (PARTITION BY Ticker_symbol ORDER BY YEAR(period_ending)) AS prev2
    FROM fundamentals
    WHERE capital_expenditures IS NOT NULL
),
capex_growth_streaks AS (
    SELECT *,
           CASE 
               WHEN capital_expenditures > prev1 AND prev1 > prev2 THEN 1
               ELSE 0
           END AS is_3_year_streak
    FROM capex_with_lag
)
SELECT 
    Ticker_symbol AS `Ticker Symbol`,
    year AS `Final Year of 3-Year Increase`,
    capital_expenditures AS `CapEx Final Year`
FROM capex_growth_streaks
WHERE is_3_year_streak = 1
ORDER BY `Ticker Symbol`, `Final Year of 3-Year Increase`;
















# 7. List the top 5 years (period_ending) with the highest total
# liabilities summed over all companies.

SELECT 
    YEAR(period_ending) AS `Year`,
    ROUND(SUM(total_liabilities), 2) AS `Total Liabilities`
FROM fundamentals
WHERE total_liabilities IS NOT NULL
GROUP BY `Year`
ORDER BY `Total Liabilities` DESC
LIMIT 5;


















# 8. For each company, find the year with the maximum net cash flow from
# operating activities (net_cash_flow_operating).

SELECT Ticker_symbol AS `Ticker Symbol`,
       YEAR(period_ending) AS `Year`,
       net_cash_flow_operating AS `Net Cash Flow from Operating`
FROM fundamentals f
WHERE net_cash_flow_operating IS NOT NULL
AND NOT EXISTS (
    SELECT 1
    FROM fundamentals f2
    WHERE f2.Ticker_symbol = f.Ticker_symbol
      AND f2.net_cash_flow_operating > f.net_cash_flow_operating
);


















# 9. Find the average earnings per share (EPS) for companies where the 
# total equity exceeds 5 billion and the operating margin is greater than 10%.

SELECT 
    Ticker_symbol AS `Ticker Symbol`,
    ROUND(AVG(earnings_per_share), 2) AS `Average EPS`
FROM fundamentals
WHERE total_equity > 5000000000
  AND operating_margin > 0.10
  AND earnings_per_share IS NOT NULL
GROUP BY Ticker_symbol
ORDER BY `Average EPS` DESC;



















# 10. Determine the correlation (using MySQL approximate calculation) between research and development
# expenses and net income for a selected company (ticker_symbol = 'AAL').

SELECT 
    (
        (COUNT(*) * SUM(research_and_development * net_income) - SUM(research_and_development) * SUM(net_income))
        /
        (SQRT(
            (COUNT(*) * SUM(POW(research_and_development, 2)) - POW(SUM(research_and_development), 2)) *
            (COUNT(*) * SUM(POW(net_income, 2)) - POW(SUM(net_income), 2))
        ))
    ) AS correlation
FROM fundamentals
WHERE Ticker_symbol = 'AAL'
  AND research_and_development IS NOT NULL
  AND net_income IS NOT NULL;
