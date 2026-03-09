--Checking for NULL in order_id, order_item_id

SELECT *
FROM staging.dataco_supplychain_stg
WHERE order_id IS NULL ;

--Checking for duplicate values

SELECT order_id, Product_Card_Id, COUNT(*)
FROM staging.dataco_supplychain_stg
GROUP BY order_id, Product_Card_Id
HAVING COUNT(*) > 1 ;

--check the order_item to see if we can make it the grain of the data

SELECT order_item_id, COUNT(*)
FROM staging.dataco_supplychain_stg
GROUP BY order_item_id
HAVING COUNT(*) > 1 ;


--Incase there are duplicates,deleting the duplicate values in the table

DELETE FROM staging.dataco_supplychain_stg
WHERE order_id IN (
            SELECT order_id
            FROM (
                    SELECT order_id,
                        ROW_NUMBER()OVER(PARTITION BY order_id) AS rn
                    FROM staging.dataco_supplychain_stg
                 ) j   
                    WHERE rn > 1
                   );
        
--or you can use a cte--

WITH duplicate_table AS (
    SELECT order_id,
        ROW_NUMBER() OVER (PARTITION BY order_id) AS rn
    FROM staging.dataco_supplychain_stg
                        )
DELETE FROM staging.dataco_supplychain_stg
WHERE order_id IN (
        SELECT order_id
        FROM duplicate_table
        WHERE rn > 1
                 )                        
