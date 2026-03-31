--schema rebuild to eradicate the order_zipcode column
--1. Empty the fact table and the dimension table together
TRUNCATE TABLE core.fact_order_item, core.dim_order_location RESTART IDENTITY;

--2. Reload the dimension table from the saved script
--3. check for duplicates after reload
SELECT 
    order_country,
    order_region,
    order_city,
    COUNT(*) as cnt
FROM core.dim_order_location
GROUP BY
    order_country,
    order_region,
    order_city
HAVING COUNT(*) > 1;

--4. Add uniqueness constraint
ALTER TABLE core.dim_order_location
ADD CONSTRAINT uq_dim_order_location
UNIQUE (order_country, order_region, order_city)

--5. Reload the fact table 

--6. Validate the fix
