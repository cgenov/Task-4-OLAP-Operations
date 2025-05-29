CREATE TABLE sales_sample ( 
	Product_Id INT, 
	Region VARCHAR(50), 
	Date DATE, 
	Sales_amount NUMERIC
	);

INSERT INTO sales_sample (Product_Id, Region, Date, Sales_Amount) VALUES
	(101, 'East', '2024-01-15', 5000),
	(102, 'West', '2024-01-20', 6500),
	(101, 'North', '2024-02-01', 4500),
	(103, 'South', '2024-02-15', 7200),
	(102, 'East', '2024-03-01', 5800),
	(104, 'West', '2024-03-15', 8900),
	(103, 'North', '2024-04-01', 6300),
	(104, 'South', '2024-04-15', 7500),
	(101, 'West', '2024-05-01', 6100),
	(102, 'East', '2024-05-15', 5400);

SELECT * FROM sales_sample;

-- a) DRILL DOWN
SELECT 
    Region,
    Product_Id,
    SUM(Sales_amount) as Total_Sales,
    COUNT(*) as Number_of_Transactions
FROM sales_sample
GROUP BY ROLLUP(Region, Product_Id)
ORDER BY Region NULLS LAST, Product_Id NULLS LAST;

-- b) ROLLUP
SELECT 
    Product_Id,
    Region,
    SUM(Sales_amount) as Total_Sales
FROM sales_sample
GROUP BY ROLLUP(Product_Id, Region)
ORDER BY Product_Id NULLS LAST, Region NULLS LAST;

-- c) CUBE
SELECT 
    Region,
    Product_Id,
    DATE_TRUNC('month', Date) as Month,
    SUM(Sales_amount) as Total_Sales
FROM sales_sample
GROUP BY CUBE(Region, Product_Id, DATE_TRUNC('month', Date))
ORDER BY Region NULLS LAST, 
         Product_Id NULLS LAST, 
         Month NULLS LAST;

-- d) SLICE (Example 1: Slice by Region)
SELECT 
    Product_Id,
    Date,
    Sales_amount
FROM sales_sample
WHERE Region = 'East'
ORDER BY Date;

-- SLICE (Example 2: Slice by Date Range)
SELECT 
    Region,
    Product_Id,
    Sales_amount
FROM sales_sample
WHERE Date BETWEEN '2024-01-01' AND '2024-03-31'
ORDER BY Date;

-- e) DICE
SELECT 
    Region,
    Product_Id,
    Date,
    Sales_amount
FROM sales_sample
WHERE Region IN ('East', 'West')
    AND Product_Id IN (101, 102)
    AND Date BETWEEN '2024-01-01' AND '2024-03-31'
ORDER BY Date;
