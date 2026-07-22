#### **Cleaning of Datasets**



The Tables were stacked one upon another , i separated each table and saved them in different sheets , deleted the empty columns , deleted the vacant rows. Filled the empty with zero values and values to be filled according to data profile. I trimmed all the extra spaces in cells altogether. The years were divided in columns, i used the power query and unpivot the other column so that i can analyse the data better. I researched and understood various metrics and filled up the empty spaces ( you need to understand the logic of calculation to fill the empty data). The three sheets mathematical logic of handling datasets to fill cells named profit and loss, balance sheet and cash flow are given below.



##### **Profit and Loss sheet:**



###### **After cleaning the dataset I typed zero in empty cell, but I found out that net income from continuing operations cant be zero because:**

&#x20;

* Consolidated net income is not zero.
* NET INCOME ATTRIBUTABLE TO SHAREOWNERS OF THE COCA-COLA COMPANY is not zero.
* Income (Loss) from Discontinued Operations, Net of Tax, Including Portion Attributable to Noncontrolling Interest are zero.





###### **Solution:**



Since Income (Loss) from Discontinued Operations, Net of Tax, Including Portion Attributable to Noncontrolling Interest is zero so Net income from continuing operations will have the same value as CONSOLIDATED NET INCOME because:

CONSOLIDATED NET INCOME = Net income from continuing operations - Income (Loss) from Discontinued Operations, Net of Tax, Including Portion Attributable to Noncontrolling Interest

and NET INCOME ATTRIBUTABLE TO SHAREOWNERS OF THE COCA-COLA COMPANY = CONSOLIDATED NET INCOME - Less: Net income attributable to noncontrolling interests.





##### **Balance Sheet:**



Asset held for sale was use used two times in metrics column but their fiscal year value was different so **i named it as Asset held for sale\_1 and Asset held for sale\_2.**

Look at row 2, row 3 and row 4 and column FY 18:

What is NOT added (The Trap)

Cash and cash equivalents: 8,926

Short-term investments: 2,025

Total cash, cash equivalents and short-term investments: 10,951. Notice that Row 2 (8,926) + Row 3 (2,025) exactly equals Row 4 (10,951). Row 3 is just a subtotal. It is an umbrella term that combines the first two lines into one convenient number. The Rule: When calculating the final Total current assets, you cannot add

Row 2, Row 3, and Row 4. If you do, you are counting the exact same money twice!

**How to Calculate it Correctly (What IS added):**

To get the true Total current assets, the accountants start with that subtotal (Row 4) and then add the rest of the individual categories below it.

Here is the exact math they used to get 30,634:

10,951 (The combined cash subtotal from Row 4)

\+ 5,013 (Marketable securities)

\+ 3,396 (Trade accounts receivable)

\+ 2,766 (Inventories)

\+ 1,962 (Prepaid expenses)

\+ 6,546 (Assets held for sale\_1)

\+ 0 (Assets held for sale\_2)

= 30,634 (Total current assets)

Whenever you read financial statements, you always have to watch out for these subtotal rows. They are placed there to help summarize information, but if you don't skip over the individual parts that make up that subtotal, your final math will always be inflated!



**Renaming ROW 4: So its better to name Row 4 as Total cash(Cash and cash equivalents + Short-term investment), so that i can use it better for analysis and track their year record as a whole.**



##### **Cash flow statement cleaning:**



Corrected the calculation of Net income from continuing operations.

