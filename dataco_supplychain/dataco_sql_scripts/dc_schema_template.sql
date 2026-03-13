--This is is the first table created to import data into postgres;
--it goes into the raw schema.

CREATE TABLE IF NOT EXISTS raw.dataco_supplychain_raw (
        Type TEXT,
        Days_for_shipping_real TEXT,
        Days_for_shipment_scheduled TEXT,
        Benefit_per_order TEXT,
        Sales_per_customer  TEXT,
        Delivery_Status TEXT,
        Late_delivery_risk TEXT,
        Category_Id TEXT,
        Category_Name TEXT,
        Customer_City TEXT,
        Customer_Country TEXT,
        Customer_Email TEXT,
        Customer_Fname TEXT,
        Customer_Id TEXT,
        Customer_Lname TEXT,
        Customer_Password TEXT,
        Customer_Segment TEXT,
        Customer_State TEXT,
        Customer_Street TEXT,
        Customer_Zipcode TEXT,
        Department_Id TEXT,
        Department_Name TEXT,
        Latitude TEXT,
        Longitude TEXT,
        Market TEXT,
        Order_City TEXT,
        Order_Country TEXT,
        Order_Customer_Id TEXT,
        order_date_DateOrders TEXT,
        Order_Id TEXT,
        Order_Item_Cardprod_Id TEXT,
        Order_Item_Discount TEXT,
        Order_Item_Discount_Rate TEXT,
        Order_Item_Id TEXT,
        Order_Item_Product_Price TEXT,
        Order_Item_Profit_Ratio TEXT,
        Order_Item_Quantity TEXT,
        Sales TEXT,
        Order_Item_Total TEXT,
        Order_Profit_Per_Order TEXT,
        Order_Region TEXT,
        Order_State TEXT,
        Order_Status TEXT,
        Order_Zipcode TEXT,
        Product_Card_Id TEXT,
        Product_Category_Id TEXT,
        Product_Description TEXT,
        Product_Image TEXT,
        Product_Name TEXT,
        Product_Price TEXT,
        Product_Status TEXT,
        shipping_date_DateOrders TEXT,
        Shipping_Mode TEXT
);

--clean table with correct data types and constraints

CREATE TABLE IF NOT EXISTS staging.dataco_supplychain_stg(
        load_id BIGSERIAL PRIMARY KEY,
        ingested_at TIMESTAMP NOT NULL DEFAULT now(),
        source_table TEXT NOT NULL DEFAULT 'raw.dataco_supplychain_raw',
        record_type TEXT NOT NULL,
        Days_for_shipping_real INTEGER,
        Days_for_shipment_scheduled INTEGER,
        Benefit_per_order NUMERIC(12,2),
        Sales_per_customer  NUMERIC(12,2),
        Delivery_Status TEXT,
        Late_delivery_risk BOOLEAN,
        Category_Id BIGINT,
        Category_Name TEXT,
        Customer_City TEXT,
        Customer_Country TEXT,
        Customer_Fname TEXT,
        Customer_Id BIGINT,
        Customer_Lname TEXT,
        Customer_Segment TEXT,
        Customer_State TEXT,
        Customer_Street TEXT,
        Customer_Zipcode TEXT,
        Department_Id BIGINT,
        Department_Name TEXT,
        Latitude NUMERIC(9,6),
        Longitude NUMERIC(9,6),
        Market TEXT,
        Order_City TEXT,
        Order_Country TEXT,
        Order_Customer_Id BIGINT,
        order_date_ts TIMESTAMP,
        Order_Id BIGINT,
        Order_Item_Cardprod_Id BIGINT,
        Order_Item_Discount NUMERIC(12,2),
        Order_Item_Discount_Rate NUMERIC(9,6),
        Order_Item_Id BIGINT,
        Order_Item_Product_Price NUMERIC(12,2),
        Order_Item_Profit_Ratio NUMERIC(9,6),
        Order_Item_Quantity INTEGER,
        Sales NUMERIC(12,2),
        Order_Item_Total NUMERIC(12,2),
        Order_Profit_Per_Order NUMERIC(12,2),
        Order_Region TEXT,
        Order_State TEXT,
        Order_Status TEXT,
        Order_Zipcode TEXT,
        Product_Card_Id BIGINT,
        Product_Category_Id BIGINT,
        Product_Description TEXT,
        Product_Name TEXT,
        Product_Price numeric(12,2),
        Product_Status INTEGER,
        shipping_date_ts TIMESTAMP,
        Shipping_Mode TEXT,
        dq_notes TEXT,

        CONSTRAINT uq_order_item UNIQUE (Order_Id, Order_Item_Id)
);

--insert into the clean table from the raw table to the staging schema

INSERT INTO staging.dataco_supplychain_stg(
        record_type,
        Days_for_shipping_real,
        Days_for_shipment_scheduled,
        Benefit_per_order,
        Sales_per_customer,
        Delivery_Status,
        Late_delivery_risk,
        Category_Id,
        Category_Name,
        Customer_City,
        Customer_Country,
        Customer_Fname,
        Customer_Id,
        Customer_Lname,
        Customer_Segment,
        Customer_State,
        Customer_Street,
        Customer_Zipcode,
        Department_Id,
        Department_Name,
        Latitude,
        Longitude,
        Market,
        Order_City,
        Order_Country,
        Order_Customer_Id,
        order_date_ts,
        Order_Id,
        Order_Item_Cardprod_Id,
        Order_Item_Discount,
        Order_Item_Discount_Rate,
        Order_Item_Id,
        Order_Item_Product_Price,
        Order_Item_Profit_Ratio,
        Order_Item_Quantity,
        Sales,
        Order_Item_Total,
        Order_Profit_Per_Order,
        Order_Region,
        Order_State,
        Order_Status,
        Order_Zipcode,
        Product_Card_Id,
        Product_Category_Id,
        Product_Description,
        Product_Name,
        Product_Price,
        Product_Status,
        shipping_date_ts,
        Shipping_Mode,
        dq_notes
)
SELECT
        NULLIF(BTRIM(Type),'') AS record_type,
        CASE
        WHEN BTRIM(Days_for_shipping_real) ~ '^-?\d+$' 
          THEN BTRIM(Days_for_shipping_real)::integer
        END,
        CASE
        WHEN Days_for_shipment_scheduled ~ '^-?\d+$' 
          THEN Days_for_shipment_scheduled::integer
        END,
        CASE
        WHEN Benefit_per_order ~ '^-?\d+(\.\d+)?$' 
          THEN Benefit_per_order::numeric(12,2)
        END,
        CASE
        WHEN Sales_per_customer ~ '^-?\d+(\.\d+)?$' 
          THEN Sales_per_customer::numeric(12,2)
        END,
        NULLIF(BTRIM(Delivery_Status),''),
        CASE
        WHEN NULLIF(BTRIM(Late_delivery_risk),'') IS NULL THEN NULL
        WHEN NULLIF(BTRIM(Late_delivery_risk),'') IN ('TRUE','T','t','true','1','YES','Y','y') THEN TRUE
        WHEN NULLIF(BTRIM(Late_delivery_risk),'') IN ('0','FALSE','F','f','NO','N','n','false') THEN FALSE
        ELSE NULL
        END,
        CASE
        WHEN BTRIM(Category_Id) ~ '^\d+$' 
         THEN BTRIM(Category_Id)::bigint
        END,
        NULLIF(BTRIM(Category_Name),''),
        NULLIF(BTRIM(Customer_City),''),
        NULLIF(BTRIM(Customer_Country),''),
        NULLIF(BTRIM(Customer_Fname),''),
        CASE
        WHEN BTRIM(Customer_Id) ~ '^\d+$' 
          THEN BTRIM(Customer_Id)::bigint
        END,
        NULLIF(BTRIM(Customer_Lname),''),
        NULLIF(BTRIM(Customer_Segment),''),
        CASE
        WHEN NULLIF(BTRIM(Customer_State),'') IS NULL THEN NULL
        WHEN BTRIM(Customer_State) ~ '^\d+$' THEN NULL
        ELSE NULLIF(BTRIM(Customer_State),'')
        END,
        NULLIF(BTRIM(Customer_Street),''),
        NULLIF(BTRIM(Customer_Zipcode),''),
        CASE
        WHEN Department_Id ~ '^\d+$' 
          THEN Department_Id::bigint
        END,
        NULLIF(BTRIM(Department_Name),''),
        CASE
        WHEN Latitude ~ '^-?\d+(\.\d+)?$' 
          THEN Latitude::numeric(9,6)
        END,
        CASE
        WHEN Longitude ~ '^-?\d+(\.\d+)?$' 
          THEN Longitude::numeric(9,6)
        END,
        NULLIF(BTRIM(Market),''),
        NULLIF(
                REGEXP_REPLACE(
                        REGEXP_REPLACE(BTRIM(Order_City),'[^[:alnum:][:space:]\-''.]','','g'),
                        '[[:space:]]+',' ','g'),''),
        NULLIF(
                REGEXP_REPLACE(
                        REGEXP_REPLACE(BTRIM(Order_Country),'[^[:alnum:][:space:]\-''.]','','g'),
                        '[[:space:]]+',' ','g'),''),
        CASE
        WHEN Order_Customer_Id ~ '^\d+$' 
          THEN Order_Customer_Id::bigint
        END,
        CASE
        WHEN NULLIF(order_date_DateOrders,'') IS NULL THEN NULL 
        WHEN BTRIM(order_date_DateOrders) ~ '^\d{2}/\d{2}/\d{4} \d{2}:\d{2}$' THEN
        TO_TIMESTAMP(BTRIM(order_date_DateOrders),'MM/DD/YYYY HH24:MI') 
        ELSE NULL
        END AS order_date_ts,
        CASE
        WHEN BTRIM(Order_Id) ~ '^\d+$' 
          THEN BTRIM(Order_Id)::bigint
        END,
        CASE
        WHEN BTRIM(Order_Item_Cardprod_Id) ~ '^\d+$' 
          THEN BTRIM(Order_Item_Cardprod_Id)::bigint
        END,
        CASE
        WHEN BTRIM(Order_Item_Discount) ~ '^-?\d+(\.\d+)?$' 
          THEN BTRIM(Order_Item_Discount)::numeric(12,2)
        END,
        CASE
        WHEN BTRIM(Order_Item_Discount_Rate) ~ '^-?\d+(\.\d+)?$' 
          THEN BTRIM(Order_Item_Discount_Rate)::numeric(9,6)
        END,
        CASE
        WHEN BTRIM(Order_Item_Id) ~ '^\d+$' 
          THEN BTRIM(Order_Item_Id)::bigint
        END,
        CASE
        WHEN BTRIM(Order_Item_Product_Price) ~ '^\d+(\.\d+)?$' 
          THEN BTRIM(Order_Item_Product_Price)::numeric(12,2)
        END,
        CASE
        WHEN BTRIM(Order_Item_Profit_Ratio) ~ '^-?\d+(\.\d+)?$' 
          THEN BTRIM(Order_Item_Profit_Ratio)::numeric(9,6)
        END,
        CASE
        WHEN BTRIM(Order_Item_Quantity) ~ '^\d+$' 
          THEN BTRIM(Order_Item_Quantity)::int
        END,
        CASE
        WHEN BTRIM(Sales) ~ '^\d+(\.\d+)?$' 
          THEN BTRIM(Sales)::numeric(12,2)
        END,
        CASE
        WHEN BTRIM(Order_Item_Total) ~ '^\d+(\.\d+)?$' 
          THEN BTRIM(Order_Item_Total)::numeric(12,2)
        END,
        CASE
        WHEN BTRIM(Order_Profit_Per_Order) ~ '^-?\d(\.\d+)?$' 
          THEN BTRIM(Order_Profit_Per_Order)::numeric(12,2)
        END,
        NULLIF(BTRIM(Order_Region),''),
        NULLIF(
                REGEXP_REPLACE(
                        REGEXP_REPLACE(BTRIM(Order_state),'[^[:alnum:][:space:]\-''.]','','g'),
                        '[[:space:]]+',' ','g'),''),
        NULLIF(BTRIM(Order_Status),''),
        NULLIF(BTRIM(Order_Zipcode),''),
        CASE
        WHEN BTRIM(Product_Card_Id) ~ '^\d+$' 
          THEN BTRIM(Product_Card_Id)::bigint
        END,
        CASE
        WHEN BTRIM(Product_Category_Id) ~ '^\d+$' 
          THEN BTRIM(Product_Category_Id)::bigint
        END,
        NULLIF(BTRIM(Product_Description),''),
        NULLIF(BTRIM(Product_Name),''),
        CASE
        WHEN BTRIM(Product_Price) ~ '^\d+(\.\d+)?$' 
          THEN BTRIM(Product_Price)::numeric(12,2)
        END,
        CASE 
        WHEN btrim(Product_Status) ~ '^-?\d+$' 
          THEN btrim(Product_Status)::int 
        END,
        CASE
        WHEN NULLIF(shipping_date_DateOrders,'') IS NULL THEN NULL 
        WHEN BTRIM(shipping_date_DateOrders) ~ '^\d{2}/\d{2}/\d{4} \d{2}:\d{2}$' THEN
        TO_TIMESTAMP(BTRIM(shipping_date_DateOrders),'MM/DD/YYYY HH24:MI') 
        ELSE NULL
        END AS shipping_date_ts,
        NULLIF(BTRIM(Shipping_Mode),''),
        CONCAT_WS(' | ',
        CASE
        WHEN NULLIF(BTRIM(Order_Id),'') IS NULL OR Order_Id !~ '^\d+$'
        THEN 'bad order_id'
        END,
        CASE
        WHEN NULLIF(BTRIM(Customer_State),'') IS NOT NULL AND
        BTRIM(Customer_State) ~ '^\d+$' THEN 'numeric customer_state'
        END,
        CASE
        WHEN (Order_State ILIKE '%�%' OR Order_Country ILIKE '%�%' OR Order_City ILIKE '%�%') 
        THEN 'location mojibake spotted'
        END,
        CASE
        WHEN NULLIF(BTRIM(Product_Description),'') IS NULL THEN 
        'product_description missing'
        END,
        CASE
        WHEN BTRIM(Product_Status) = '0' THEN 
        'product_status is zero'
        END
        ) AS dq_notes

FROM raw.dataco_supplychain_raw ;

