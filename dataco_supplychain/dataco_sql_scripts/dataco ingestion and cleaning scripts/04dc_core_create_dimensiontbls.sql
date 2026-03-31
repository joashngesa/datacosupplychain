--schema for the dimension tables

CREATE TABLE IF NOT EXISTS core.dim_customer(
    customer_key SERIAL PRIMARY KEY,
    customer_id INT UNIQUE,
    customer_fname TEXT,
    customer_lname TEXT,
    customer_segment TEXT
);

CREATE TABLE IF NOT EXISTS core.dim_customer_location(
    customer_location_key SERIAL PRIMARY KEY,
    customer_country TEXT,
    customer_state TEXT,
    customer_city TEXT,
    customer_zipcode TEXT,
    latitude numeric(9,6),
    longitude numeric(9,6)
);

CREATE TABLE IF NOT EXISTS core.dim_order_location(
    order_location_key SERIAL PRIMARY KEY,
    order_country TEXT,
    order_region TEXT,
    order_city TEXT,
    market TEXT
);

CREATE TABLE IF NOT EXISTS core.dim_category(
    category_key SERIAL PRIMARY KEY,
    category_id INT UNIQUE,
    category_name TEXT,
    department_id INT,
    department_name TEXT
);

CREATE TABLE IF NOT EXISTS core.dim_shipment(
    shipment_key SERIAL PRIMARY KEY,
    shipping_mode TEXT
);

CREATE TABLE IF NOT EXISTS core.dim_product(
    product_key SERIAL PRIMARY KEY,
    product_card_id INT UNIQUE,
    product_category_id INT,
    category_id INT,
    product_status INT,
    product_price numeric(12,2)
    product_name TEXT
);

CREATE TABLE IF NOT EXISTS core.dim_date(
    date_key INT PRIMARY KEY,
    full_date DATE NOT NULL UNIQUE,
    is_weekend BOOLEAN NOT NULL,
    day_of_week INT NOT NULL,
    day_name TEXT NOT NULL, 
    day_of_month INT NOT NULL,
    month INT NOT NULL,
    month_name TEXT NOT NULL,
    quarter INT NOT NULL,
    year INT NOT NULL,
    week_of_year INT 
);











