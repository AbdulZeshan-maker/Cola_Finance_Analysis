##### **All MySQL queries  for reding purpose(Incase you don't want to load the sql file in MySQL)**



use finance;

/\* 1. Top-Line vs. Bottom-Line Growth (Income Statement)

This query pulls the absolute Revenue and Net Income side-by-side to track overall

corporate growth. \*/

SELECT 

&#x20;   Fiscal\_Year,

&#x20;   SUM(CASE WHEN Metric = 'NET OPERATING REVENUES' THEN Amount ELSE 0 END) AS Total\_Revenue,

&#x20;   SUM(CASE WHEN Metric = 'CONSOLIDATED NET INCOME' THEN Amount ELSE 0 END) AS Net\_Income

FROM pl\_trans

WHERE Metric IN ('NET OPERATING REVENUES', 'CONSOLIDATED NET INCOME')

GROUP BY Fiscal\_Year

ORDER BY Fiscal\_Year;

/\* 2. Gross Profit Margin Analysis (Income Statement)

Gross Margin shows the percentage of revenue left after deducting the direct costs

of producing goods. \*/

SELECT 

&#x20;   Fiscal\_Year,

&#x20;   SUM(CASE WHEN Metric = 'NET OPERATING REVENUES' THEN Amount ELSE 0 END) AS Revenue,

&#x20;   SUM(CASE WHEN Metric = 'Gross Profit' THEN Amount ELSE 0 END) AS Gross\_Profit,

&#x20;   ROUND((SUM(CASE WHEN Metric = 'Gross Profit' THEN Amount ELSE 0 END) / 

&#x20;          SUM(CASE WHEN Metric = 'NET OPERATING REVENUES' THEN Amount ELSE 0 END)) \* 100, 2)

&#x20;          AS Gross\_Margin\_Pct

FROM pl\_trans

WHERE Metric IN ('NET OPERATING REVENUES', 'Gross Profit')

GROUP BY Fiscal\_Year

ORDER BY Fiscal\_Year;

/\* 3. Operating Margin (Income Statement)

This reveals how efficiently the core business operates before taxes and interest are applied. \*/

SELECT 

&#x20;   Fiscal\_Year,

&#x20;   SUM(CASE WHEN Metric = 'Operating Income' THEN Amount ELSE 0 END) AS Operating\_Income,

&#x20;   SUM(CASE WHEN Metric = 'NET OPERATING REVENUES' THEN Amount ELSE 0 END) AS Revenue,

&#x20;   ROUND((SUM(CASE WHEN Metric = 'Operating Income' THEN Amount ELSE 0 END) / 

&#x20;          SUM(CASE WHEN Metric = 'NET OPERATING REVENUES' THEN Amount ELSE 0 END)) \* 100, 2)

&#x20;          AS Operating\_Margin\_Pct

FROM pl\_trans

WHERE Metric IN ('Operating Income', 'NET OPERATING REVENUES')

GROUP BY Fiscal\_Year

ORDER BY Fiscal\_Year;

/\* 4. Current Ratio / Liquidity Health (Balance Sheet)

A standard financial health check. A ratio greater than 1.0 means the company can cover 

its short-term debts.

Measure short-term liquidity \*/

SELECT 

&#x20;   Fiscal\_Year,

&#x20;   SUM(CASE WHEN Metric = 'Total current assets' THEN Amount ELSE 0 END) AS Current\_Assets,

&#x20;   SUM(CASE WHEN Metric = 'Total current liabilities' THEN Amount ELSE 0 END)

&#x20;   AS Current\_Liabilities,

&#x20;   ROUND(SUM(CASE WHEN Metric = 'Total current assets' THEN Amount ELSE 0 END) / 

&#x20;         SUM(CASE WHEN Metric = 'Total current liabilities' THEN Amount ELSE 0 END), 2)

&#x20;         AS Current\_Ratio

FROM bs\_trans

WHERE Metric IN ('Total current assets', 'Total current liabilities')

GROUP BY Fiscal\_Year

ORDER BY Fiscal\_Year;

/\* 5. Financial Leverage / Solvency (Balance Sheet)

Calculates the Debt-to-Equity ratio to determine how aggressively the company

is financing its operations through debt. \*/

SELECT 

&#x20;   Fiscal\_Year,

&#x20;   SUM(CASE WHEN Metric = 'Long-term debt' THEN Amount ELSE 0 END) AS Long\_Term\_Debt,

&#x20;   SUM(CASE WHEN Metric = 'Total equity' THEN Amount ELSE 0 END) AS Total\_Equity,

&#x20;   ROUND(SUM(CASE WHEN Metric = 'Long-term debt' THEN Amount ELSE 0 END) / 

&#x20;         SUM(CASE WHEN Metric = 'Total equity' THEN Amount ELSE 0 END), 2)

&#x20;         AS Debt\_To\_Equity\_Ratio

FROM bs\_trans

WHERE Metric IN ('Long-term debt', 'Total equity')

GROUP BY Fiscal\_Year

ORDER BY Fiscal\_Year;

/\* 6. Free Cash Flow Generation (Cash Flow Statement)

Free Cash Flow (FCF) is the cash available after maintaining capital assets.

It is highly scrutinized by investors. \*/

SELECT 

&#x20;   Fiscal\_Year,

&#x20;   SUM(CASE WHEN Metric = 'Net cash provided by operating activities' THEN Amount ELSE 0 END)

&#x20;   AS Operating\_Cash,

&#x20;   SUM(CASE WHEN Metric = 'Purchases of property, plant and equipment' THEN Amount ELSE 0 END)

&#x20;   AS CapEx,

&#x20;   (SUM(CASE WHEN Metric = 'Net cash provided by operating activities' THEN Amount ELSE 0 END) - 

&#x20;    SUM(CASE WHEN Metric = 'Purchases of property, plant and equipment' THEN Amount ELSE 0 END))

&#x20;    AS Free\_Cash\_Flow

FROM cs\_trans

WHERE Metric IN ('Net cash provided by operating activities', 'Purchases of property, plant and equipment')

GROUP BY Fiscal\_Year

ORDER BY Fiscal\_Year;

/\* 7. Capital Intensity Ratio (P\&L + Cash Flow)

&#x20;  Shows how much revenue is being reinvested into physical assets like property and equipment. \*/

SELECT 

&#x20;   p.Fiscal\_Year,

&#x20;   p.Amount AS Total\_Revenue,

&#x20;   c.Amount AS CapEx,

&#x20;   ROUND((c.Amount / p.Amount) \* 100, 2) AS CapEx\_To\_Revenue\_Pct

FROM pl\_trans p

JOIN cs\_trans c ON p.Fiscal\_Year = c.Fiscal\_Year

WHERE p.Metric = 'NET OPERATING REVENUES' 

&#x20; AND c.Metric = 'Purchases of property, plant and equipment'

ORDER BY p.Fiscal\_Year;

/\* 8. Return on Equity (P\&L + Balance Sheet)

Return on Equity (ROE) measures how effectively management uses shareholder

&#x20;capital to generate profit. \*/

SELECT 

&#x20;   p.Fiscal\_Year,

&#x20;   p.Amount AS Net\_Income,

&#x20;   b.Amount AS Total\_Equity,

&#x20;   ROUND((p.Amount / b.Amount) \* 100, 2) AS Return\_On\_Equity\_Pct

FROM pl\_trans p

JOIN bs\_trans b ON p.Fiscal\_Year = b.Fiscal\_Year

WHERE p.Metric = 'CONSOLIDATED NET INCOME' 

&#x20; AND b.Metric = 'Total equity'

ORDER BY p.Fiscal\_Year;

/\* 9. Quality of Earnings (P\&L + Cash Flow)

Calculates the Cash Conversion Ratio. If Net Income is high but Operating Cash is low,

it indicates aggressive accounting. \*/

SELECT 

&#x20;   p.Fiscal\_Year,

&#x20;   p.Amount AS Net\_Income,

&#x20;   c.Amount AS Operating\_Cash\_Flow,

&#x20;   ROUND((c.Amount / p.Amount), 2) AS Cash\_Conversion\_Ratio

FROM pl\_trans p

JOIN cs\_trans c ON p.Fiscal\_Year = c.Fiscal\_Year

WHERE p.Metric = 'CONSOLIDATED NET INCOME' 

&#x20; AND c.Metric = 'Net cash provided by operating activities'

ORDER BY p.Fiscal\_Year;

/\* 10. Year-over-Year (YoY) Revenue Growth (Advanced SQL)

Uses the LAG() window function to calculate the percentage growth

compared to the previous fiscal year. \*/

WITH Revenue\_Data AS (

&#x20;   SELECT Fiscal\_Year, Amount AS Revenue

&#x20;   FROM pl\_trans

&#x20;   WHERE Metric = 'NET OPERATING REVENUES'

)

SELECT 

&#x20;   Fiscal\_Year,

&#x20;   Revenue,

&#x20;   LAG(Revenue) OVER (ORDER BY Fiscal\_Year) AS Prev\_Year\_Revenue,

&#x20;   ROUND(((Revenue - LAG(Revenue) OVER (ORDER BY Fiscal\_Year)) / 

&#x20;          LAG(Revenue) OVER (ORDER BY Fiscal\_Year)) \* 100, 2) AS YoY\_Revenue\_Growth\_Pct

FROM Revenue\_Data;

