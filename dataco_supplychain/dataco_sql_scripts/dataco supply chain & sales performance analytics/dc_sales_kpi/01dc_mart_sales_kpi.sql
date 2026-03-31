-- SUBJECT: KPI ANALYSIS
-- PURPOSE: BUSINESS PERFORMANCE METRICS
-- GRAIN: ENTIRE DATASET(no grouping initially)

--SUPPLYCHAIN QUESTIONS 
--1. What is total revenue?
--2. What is total profit?
--3. What is the total number of orders?
--4. What is the total quantity sold?
--5. What is the average order value?
--6. What is the total discount given?

--1. Revenue?

SELECT SUM(sales)
FROM core.fact_order_item ;

--2. Profit

