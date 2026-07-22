use finance;
/* 1. Top-Line vs. Bottom-Line Growth (Income Statement)
This query pulls the absolute Revenue and Net Income side-by-side to track overall
corporate growth. */
SELECT 
    Fiscal_Year,
    SUM(CASE WHEN Metric = 'NET OPERATING REVENUES' THEN Amount ELSE 0 END) AS Total_Revenue,
    SUM(CASE WHEN Metric = 'CONSOLIDATED NET INCOME' THEN Amount ELSE 0 END) AS Net_Income
FROM pl_trans
WHERE Metric IN ('NET OPERATING REVENUES', 'CONSOLIDATED NET INCOME')
GROUP BY Fiscal_Year
ORDER BY Fiscal_Year;
/* 2. Gross Profit Margin Analysis (Income Statement)
Gross Margin shows the percentage of revenue left after deducting the direct costs
of producing goods. */
SELECT 
    Fiscal_Year,
    SUM(CASE WHEN Metric = 'NET OPERATING REVENUES' THEN Amount ELSE 0 END) AS Revenue,
    SUM(CASE WHEN Metric = 'Gross Profit' THEN Amount ELSE 0 END) AS Gross_Profit,
    ROUND((SUM(CASE WHEN Metric = 'Gross Profit' THEN Amount ELSE 0 END) / 
           SUM(CASE WHEN Metric = 'NET OPERATING REVENUES' THEN Amount ELSE 0 END)) * 100, 2)
           AS Gross_Margin_Pct
FROM pl_trans
WHERE Metric IN ('NET OPERATING REVENUES', 'Gross Profit')
GROUP BY Fiscal_Year
ORDER BY Fiscal_Year;
/* 3. Operating Margin (Income Statement)
This reveals how efficiently the core business operates before taxes and interest are applied. */
SELECT 
    Fiscal_Year,
    SUM(CASE WHEN Metric = 'Operating Income' THEN Amount ELSE 0 END) AS Operating_Income,
    SUM(CASE WHEN Metric = 'NET OPERATING REVENUES' THEN Amount ELSE 0 END) AS Revenue,
    ROUND((SUM(CASE WHEN Metric = 'Operating Income' THEN Amount ELSE 0 END) / 
           SUM(CASE WHEN Metric = 'NET OPERATING REVENUES' THEN Amount ELSE 0 END)) * 100, 2)
           AS Operating_Margin_Pct
FROM pl_trans
WHERE Metric IN ('Operating Income', 'NET OPERATING REVENUES')
GROUP BY Fiscal_Year
ORDER BY Fiscal_Year;
/* 4. Current Ratio / Liquidity Health (Balance Sheet)
A standard financial health check. A ratio greater than 1.0 means the company can cover 
its short-term debts.
Measure short-term liquidity */
SELECT 
    Fiscal_Year,
    SUM(CASE WHEN Metric = 'Total current assets' THEN Amount ELSE 0 END) AS Current_Assets,
    SUM(CASE WHEN Metric = 'Total current liabilities' THEN Amount ELSE 0 END)
    AS Current_Liabilities,
    ROUND(SUM(CASE WHEN Metric = 'Total current assets' THEN Amount ELSE 0 END) / 
          SUM(CASE WHEN Metric = 'Total current liabilities' THEN Amount ELSE 0 END), 2)
          AS Current_Ratio
FROM bs_trans
WHERE Metric IN ('Total current assets', 'Total current liabilities')
GROUP BY Fiscal_Year
ORDER BY Fiscal_Year;
/* 5. Financial Leverage / Solvency (Balance Sheet)
Calculates the Debt-to-Equity ratio to determine how aggressively the company
is financing its operations through debt. */
SELECT 
    Fiscal_Year,
    SUM(CASE WHEN Metric = 'Long-term debt' THEN Amount ELSE 0 END) AS Long_Term_Debt,
    SUM(CASE WHEN Metric = 'Total equity' THEN Amount ELSE 0 END) AS Total_Equity,
    ROUND(SUM(CASE WHEN Metric = 'Long-term debt' THEN Amount ELSE 0 END) / 
          SUM(CASE WHEN Metric = 'Total equity' THEN Amount ELSE 0 END), 2)
          AS Debt_To_Equity_Ratio
FROM bs_trans
WHERE Metric IN ('Long-term debt', 'Total equity')
GROUP BY Fiscal_Year
ORDER BY Fiscal_Year;
/* 6. Free Cash Flow Generation (Cash Flow Statement)
Free Cash Flow (FCF) is the cash available after maintaining capital assets.
It is highly scrutinized by investors. */
SELECT 
    Fiscal_Year,
    SUM(CASE WHEN Metric = 'Net cash provided by operating activities' THEN Amount ELSE 0 END)
    AS Operating_Cash,
    SUM(CASE WHEN Metric = 'Purchases of property, plant and equipment' THEN Amount ELSE 0 END)
    AS CapEx,
    (SUM(CASE WHEN Metric = 'Net cash provided by operating activities' THEN Amount ELSE 0 END) - 
     SUM(CASE WHEN Metric = 'Purchases of property, plant and equipment' THEN Amount ELSE 0 END))
     AS Free_Cash_Flow
FROM cs_trans
WHERE Metric IN ('Net cash provided by operating activities', 'Purchases of property, plant and equipment')
GROUP BY Fiscal_Year
ORDER BY Fiscal_Year;
/* 7. Capital Intensity Ratio (P&L + Cash Flow)
   Shows how much revenue is being reinvested into physical assets like property and equipment. */
SELECT 
    p.Fiscal_Year,
    p.Amount AS Total_Revenue,
    c.Amount AS CapEx,
    ROUND((c.Amount / p.Amount) * 100, 2) AS CapEx_To_Revenue_Pct
FROM pl_trans p
JOIN cs_trans c ON p.Fiscal_Year = c.Fiscal_Year
WHERE p.Metric = 'NET OPERATING REVENUES' 
  AND c.Metric = 'Purchases of property, plant and equipment'
ORDER BY p.Fiscal_Year;
/* 8. Return on Equity (P&L + Balance Sheet)
Return on Equity (ROE) measures how effectively management uses shareholder
 capital to generate profit. */
SELECT 
    p.Fiscal_Year,
    p.Amount AS Net_Income,
    b.Amount AS Total_Equity,
    ROUND((p.Amount / b.Amount) * 100, 2) AS Return_On_Equity_Pct
FROM pl_trans p
JOIN bs_trans b ON p.Fiscal_Year = b.Fiscal_Year
WHERE p.Metric = 'CONSOLIDATED NET INCOME' 
  AND b.Metric = 'Total equity'
ORDER BY p.Fiscal_Year;
/* 9. Quality of Earnings (P&L + Cash Flow)
Calculates the Cash Conversion Ratio. If Net Income is high but Operating Cash is low,
it indicates aggressive accounting. */
SELECT 
    p.Fiscal_Year,
    p.Amount AS Net_Income,
    c.Amount AS Operating_Cash_Flow,
    ROUND((c.Amount / p.Amount), 2) AS Cash_Conversion_Ratio
FROM pl_trans p
JOIN cs_trans c ON p.Fiscal_Year = c.Fiscal_Year
WHERE p.Metric = 'CONSOLIDATED NET INCOME' 
  AND c.Metric = 'Net cash provided by operating activities'
ORDER BY p.Fiscal_Year;
/* 10. Year-over-Year (YoY) Revenue Growth (Advanced SQL)
Uses the LAG() window function to calculate the percentage growth
compared to the previous fiscal year. */
WITH Revenue_Data AS (
    SELECT Fiscal_Year, Amount AS Revenue
    FROM pl_trans
    WHERE Metric = 'NET OPERATING REVENUES'
)
SELECT 
    Fiscal_Year,
    Revenue,
    LAG(Revenue) OVER (ORDER BY Fiscal_Year) AS Prev_Year_Revenue,
    ROUND(((Revenue - LAG(Revenue) OVER (ORDER BY Fiscal_Year)) / 
           LAG(Revenue) OVER (ORDER BY Fiscal_Year)) * 100, 2) AS YoY_Revenue_Growth_Pct
FROM Revenue_Data;