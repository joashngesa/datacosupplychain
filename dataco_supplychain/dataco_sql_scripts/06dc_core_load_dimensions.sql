--queries to load the dimension tables in core schema

INSERT INTO core.dim_category(
    category_id,
    category_name,
    department_id,
    department_name
)
SELECT DISTINCT
    category_id,
    category_name,
    department_id,
    department_name
FROM staging.dataco_supplychain_stg;

INSERT INTO core.dim_product(
    product_card_id,
    category_key,
    product_category_id,
    product_name,
    product_status,
    product_price
)
SELECT DISTINCT
    dss.product_card_id,
    dc.category_key,
    dss.product_category_id,
    dss.product_name,
    dss.product_status,
    dss.product_price
FROM staging.dataco_supplychain_stg AS dss
LEFT JOIN core.dim_category AS dc
    ON dss.product_category_id=dc.category_id;

INSERT INTO core.dim_customer(
    customer_id,
    customer_fname,
    customer_lname,
    customer_segment
)
SELECT DISTINCT
    customer_id,
    customer_fname,
    customer_lname,
    customer_segment
FROM staging.dataco_supplychain_stg;

INSERT INTO core.dim_customer_location(
    customer_country,
    customer_state,
    customer_city,
    customer_zipcode,
    latitude,
    longitude
)
SELECT 
    customer_country,
    customer_state,
    customer_city,
    customer_zipcode,
    AVG(latitude),
    AVG(longitude)
FROM staging.dataco_supplychain_stg
GROUP BY 
    customer_country,
    customer_state,
    customer_city,
    customer_zipcode
;

INSERT INTO core.dim_order_location(
    order_country,
    order_region,
    order_city,
    order_zipcode,
    market
)
SELECT DISTINCT
    order_country,
    order_region,
    order_city,
    order_zipcode,
    market
FROM staging.dataco_supplychain_stg;

INSERT INTO core.dim_shipment(
    shipping_mode
)
SELECT DISTINCT
    shipping_mode
FROM staging.dataco_supplychain_stg;


INSERT INTO core.dim_date(
    date_key,
    full_date,
    is_weekend,
    day_of_week,
    day_name,
    day_of_month,
    month,
    month_name,
    quarter,
    year
)
SELECT 
    TO_CHAR(gns::date,'YYYYMMDD')::INT AS date_key,
    gns::date AS full_date,
    CASE
    WHEN EXTRACT(ISODOW FROM gns) IN (6,7)
        THEN true
        ELSE false
    END AS is_weekend,
    EXTRACT(ISODOW FROM gns) AS day_of_week,
    TRIM(TO_CHAR(gns::date,'day')),
    EXTRACT(DAY FROM gns) AS day_of_month,
    EXTRACT(MONTH FROM gns) AS month,
    TRIM(TO_CHAR(gns::date,'MONTH')) AS month_name,
    EXTRACT(QUARTER FROM gns) AS quarter,
    EXTRACT(YEAR FROM gns) AS year
FROM GENERATE_SERIES(
    DATE '2014-01-01',
    DATE '2027-01-01',
    INTERVAL '1 day'
) AS gns

ON CONFLICT (date_key) DO NOTHING;


--this makes this script idempotent