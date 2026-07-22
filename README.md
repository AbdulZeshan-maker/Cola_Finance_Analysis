# Cola Finance Analysis

**Tableau Dashboard: Please maximise the screen for clear view** [Click here to view the tableau dashboard](https://public.tableau.com/views/finance_17847473647620/Dashboard1?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

## Project Overview
This project demonstrates an end-to-end data analytics pipeline using a raw finance dataset for a cola brand. The workflow encompasses data cleaning and transformation in Excel, advanced querying for reporting in MySQL, and the development of an interactive performance dashboard in Tableau.

## Tools Used
* **Data Cleaning and Transformation:** Microsoft Excel
* **Database Management:** MySQL (for data loading andquerying)
* **Data Visualization:** Tableau Desktop Public (free)

## ETL Process
1. **Extraction & Cleaning:** Addressed the missing values by understanding the logic of the mathematical calculation thereby putting both values and zero as required accordingly also trimmed all the extra spaces in cells and deleted the empty column given just for description.
2. **Transformation:** Used power query to unpivot the fiscal years columns by clicking and naming the column as year and values as amount. Exported the sheets into three csv files so that i can upload it in MySQL for querying.
3. **Loading:** Imported the csv file into a MySQL database, but mapping relationship or data modelling was not possible according to data profile, so queries were typed for reporting.
4. **Visualization:** Connected Tableau to the cleaned transformed three csv files and made interactive tableau dashboard

## Key Business Insights
* **insight 1:** The debt-to-equity ratio jumped from 0.20 to 1.59. The company is aggressively borrowing money rather than using its own cash to fund operations    or shareholder payouts. Need to restructure the capital allocation strategy to manage financial risk.
* **insight 2:** Total revenue declined by 33% over the period, but operating profit margins actually increased to 27.3%. The company is selling less volume but     making more profit per sale.Identify exactly which low-margin product lines or regions caused the revenue drop.
* **insight 3:** Net income looked terrible in FY '17 (dropping to 3.6%), but this was entirely due to a massive, one-time 82% tax charge. Core business             operations were actually completely healthy that year. So later if i want to predict something ,i will exclude fiscal year 2017.
* **insight 4:** Even with falling sales, the company is highly efficient at turning its day-to-day operations into actual cash in the bank, requiring very little   money to maintain its equipment. This insight you can draw by seeing the cash flow, the company has good cash flow, it just needs to invest it into good assets.

## Repository Structure
* `01_data_explanation/`: Contains the messy excel dataset, the cleaned excel dataset, the three transformed csv dataset, the datset metrices explanation, the       datset mathematical logic explanation and also a notes which will help you understand the datset.
* `02_mysql_query/`: Contains the sql file used for query and same query as a file to read, if you dont want to load the query.
* `03_tableau_dashboard/`: Contains the finanace.twbx file and a screenshot of same tableau dashboard.
<img width="1656" height="967" alt="dashboard_image" src="https://github.com/user-attachments/assets/769f7c49-4587-431b-b479-dfdf36a8b3a8" />
