--creating the schema for dataco fact table

CREATE TABLE IF NOT EXISTS core.fact_order_item(
    order_item_id INT PRIMARY KEY,
    order_id INT,
    customer_key INT REFERENCES core.dim_customer(customer_key),
    customer_location_key INT REFERENCES core.dim_customer_location(customer_location_key),
    order_location_key INT REFERENCES core.dim_order_location(order_location_key),
    shipment_key INT REFERENCES core.dim_shipment(shipment_key),
    product_key INT REFERENCES core.dim_product(product_key),
    order_date_key INT REFERENCES core.dim_date(date_key),
    shipping_date_key INT REFERENCES core.dim_date(date_key),
    order_item_discount NUMERIC(12,2),
    order_item_discount_rate NUMERIC(9,6),
    benefit_per_order NUMERIC(12,2),
    order_item_product_price NUMERIC(12,2),
    order_item_profit_ratio NUMERIC(9,6),
    order_item_quantity INT,
    order_item_total NUMERIC(12,2),
    sales_per_customer NUMERIC(12,2),
    sales NUMERIC(12,2),
    days_for_shipment_scheduled INT,
    days_for_shipping_real INT,
    late_delivery_risk BOOLEAN,
    delivery_status TEXT
);   

