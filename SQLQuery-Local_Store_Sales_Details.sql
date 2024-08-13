/* 
SQL queries, data AGGREGATION, and basic DATA ANALYSIS using SQL Server
DATABASE Name: IMTIYAZ
TABLE Name: Local_Store_Sales_Details
***************************************************************************
***************************************************************************
*/

/*
=====================
Sales Summary Report
=====================
•	Objective:An SQL query that summarizes total sales, profit, and quantity sold for each product category and sub-category.
•	Insights: Gains experience with GROUP BY and aggregate functions like SUM() and COUNT().
___________________________________________________________________________
*/

SELECT
    Category,                             -- Grouping by the main product category
    [Sub-Category],                       -- Grouping by the sub-category within each category
    SUM(Amount) AS Total_Sales,           -- Summing the total sales amount for each category and sub-category
    SUM(Profit) AS Total_Profit,          -- Summing the total profit for each category and sub-category
    SUM(Quantity) AS Total_Quantity_Sold  -- Summing the total quantity sold for each category and sub-category
FROM
    [Local_Store_Sales_Details]
GROUP BY
    Category,               -- Group by Category to aggregate data by this column
    [Sub-Category]          -- Group by Sub-Category to further break down the data
ORDER BY
    Category,               -- Ordering the results by Category for easier readability
    [Sub-Category];         -- Ordering by Sub-Category within each Category


/* 
=====================
Top-Selling Products
=====================
•	Objective: An SQL query to identify the top 5 products with the highest sales amounts.
•	Insights: Learns how to sort results using ORDER BY and limit the number of records returned with TOP or LIMIT.
___________________________________________________________________________
*/

SELECT TOP 5
    Order_ID,              -- UNIQUE identifier for the product or order
    Category,              -- Product category
    [Sub-Category],        -- Product sub-category
    Amount AS Sales_Amount -- The sales amount for each product
FROM
    [Local_Store_Sales_Details]
ORDER BY
    Amount DESC;    -- Sorting the results by Sales_Amount in descending order to get the highest sales first


/* 
======================
Profit Margin Analysis
======================
•	Objective: Calculates the profit margin for each product and categorize products based on profitability.
•	Insights: Practices creating calculated columns and using CASE statements.
___________________________________________________________________________
*/

SELECT
    [Order_ID],        -- UNIQUE identifier for the product or order
    Category,        -- Product category
    [Sub-Category],    -- Product sub-category
    Amount,          -- Total sales amount
    Profit,          -- Profit earned from the sale

    -- Calculate the profit margin as (Profit / Amount) * 100 to get the percentage
    (Profit * 100.0 / Amount) AS Profit_Margin,

    -- Categorize the products based on the calculated profit margin
    CASE
        WHEN (Profit * 100.0 / Amount) >= 50 THEN 'High Profit'
        WHEN (Profit * 100.0 / Amount) BETWEEN 20 AND 49.99 THEN 'Moderate Profit'
        WHEN (Profit * 100.0 / Amount) BETWEEN 5 AND 19.99 THEN 'Low Profit'
        ELSE 'No or Negative Profit'
    END AS Profitability_Category
FROM
    [Local_Store_Sales_Details]
WHERE
    Amount > 0           -- Ensure we don't divide by ZERO in profit margin calculation
ORDER BY
    Profit_Margin DESC;  -- Sort the results by profit margin in descending order


/* 
======================
Payment Mode Analysis
======================
•	Objective: Analyzes which payment modes are most popular and how they correlate with different product categories.
•	Insights: Develops skills in filtering data with WHERE clauses and analyzing patterns.
___________________________________________________________________________
*/

SELECT
    PaymentMode,                   -- The payment method used by customers
    Category,                      -- The product category
    COUNT(*) AS Payment_Count,     -- Count of transactions for each payment mode and category
    SUM(Amount) AS Total_Sales     -- Total sales amount for each payment mode and category
FROM
    [Local_Store_Sales_Details]
WHERE
    PaymentMode IS NOT NULL        -- Filtering out any records where the payment mode is missing
GROUP BY
    PaymentMode,                   -- Grouping by payment mode to analyze its popularity
    Category                       -- Grouping by category to see the correlation with product categories
ORDER BY
    Payment_Count DESC;            -- Sorting by the count of payments to see the most popular payment modes first


/* 
=====================
Inventory Management
=====================
•	Objective: Creates a query to identify products with low quantities and suggest restocking.
•	Insights: Applies conditional logic with WHERE clauses to filter data based on inventory levels.
___________________________________________________________________________
*/

SELECT 
    [Sub-Category] AS Product,    -- Selecting the product name/category
    Quantity,                     -- Selecting the current quantity of the product

    -- Use conditional logic to provide restocking suggestions
    CASE 
        WHEN Quantity < 10 THEN 'Restock Needed'  -- If quantity is less than 10, suggest restocking
        ELSE 'Sufficient Stock'                   -- Otherwise, indicate that stock is sufficient
    END AS Restocking_Suggestion
FROM 
    [Local_Store_Sales_Details]   -- Specify the database and table from which to retrieve data

    -- Filter the results to only show products with low quantities
WHERE 
    Quantity < 10;                -- Apply a condition to filter out products with quantities less than 10
