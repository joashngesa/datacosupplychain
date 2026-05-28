--DATACO QUALITY CHECKS
--QC for the fact_order_item table


--NULL CHECKS
--dim_category check

SELECT
    *
FROM core.fact_order_item
limit 20;

SELECT
    COUNT(*),
    sum(CASE
        WHEN order_item_id is NULL THEN 1 ELSE 0
        END) AS order_item_id_null_count,
    sum(CASE
        WHEN sales is NULL THEN 1 ELSE 0
        END) AS sales_null_count
FROM core.fact_order_item

--or you can check for a singular column

SELECT
    COUNT(*) as total_rows,
    count(order_item_id) as non_null,
    COUNT(*) - count(order_item_id) as null_keys
from core.fact_order_item

--DUPLICATE CHECKS

SELECT 
    order_item_id,
    count(*)
FROM core.fact_order_item
GROUP BY order_item_id
HAVING count(*) > 1


SELECT 
    product_key,
    count(*)
FROM core.dim_product
GROUP BY product_key
HAVING count(*) > 1

--REFERENTIAL INTEGRITY CHECKS
--product referential integrity
SELECT
    foi.product_key,
    COUNT(*) as orphan_rows
FROM core.fact_order_item as foi
LEFT JOIN core.dim_product as dp
ON foi.product_key = dp.product_key
WHERE dp.product_key is NULL
GROUP BY foi.product_key



--customer referential integrity

SELECT
    COUNT(*),
    foi.customer_key
FROM core.fact_order_item as foi
LEFT JOIN core.dim_customer as dc
ON foi.customer_key = dc.customer_key
WHERE dc.customer_key is NULL
GROUP BY foi.customer_key


--shipment referential integrity

SELECT 
    COUNT(*),
    foi.shipment_key
FROM core.fact_order_item as foi
LEFT JOIN core.dim_shipment as ds
ON foi.shipment_key = ds.shipment_key
WHERE ds.shipment_key is NULL
GROUP BY foi.shipment_key



--NULL PROFILE

--OUTPUT:
    --order_id
    --order_item_id
    --customer_key
    --product_key
    --shipment_key
    --sales
    --order_item_quantity
    --delivery_status

SELECT
    COUNT(*),
    sum(CASE
        WHEN order_id is NULL THEN 1 ELSE 0 END)
        AS null_order_id,
    sum(CASE
        WHEN order_item_id is NULL THEN 1 ELSE 0 END)
        AS null_order_item_id,
    sum(CASE
        WHEN customer_key is NULL THEN 1 ELSE 0 END)
        AS null_customer_key,
    sum(CASE
        WHEN product_key is NULL THEN 1 ELSE 0 END)
        AS null_product_key,
    sum(CASE
        WHEN shipment_key is NULL THEN 1 ELSE 0 END)
        AS null_shipment_key
FROM core.fact_order_item


--REVENUE RECONCILIATION
WITH fact_revenue AS (
    SELECT
        SUM(sales) AS revenue
    FROM core.fact_order_item
),
joined_revenue AS (
    SELECT
        SUM(foi.sales) AS revenue
    FROM core.fact_order_item AS foi
    JOIN core.dim_product AS dp
        ON foi.product_key = dp.product_key
)
SELECT
    fr.revenue AS fact_revenue,
    jr.revenue AS joined_revenue,
    fr.revenue - jr.revenue AS difference
FROM fact_revenue fr
CROSS JOIN joined_revenue jr;


