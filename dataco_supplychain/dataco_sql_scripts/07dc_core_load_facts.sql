--Loading the fact_order_item table

INSERT INTO core.fact_order_item(
    order_item_id,
    order_id,
    customer_key,
    customer_location_key, 
    order_location_key, 
    shipment_key, 
    product_key, 
    order_date_key, 
    shipping_date_key, 
    order_item_discount, 
    order_item_discount_rate,
    benefit_per_order,
    order_item_product_price,
    order_item_profit_ratio,
    order_item_quantity,
    order_item_total,
    sales_per_customer,
    sales,
    days_for_shipment_scheduled,
    days_for_shipping_real,
    late_delivery_risk,
    delivery_status
)
SELECT 
    dsc.order_item_id,
    dsc.order_id,
    dc.customer_key,
    dcl.customer_location_key,
    dol.order_location_key,
    dsp.shipment_key,
    dpd.product_key,
    odt.date_key AS order_date_key,
    sdt.date_key AS shipping_date_key,
    dsc.order_item_discount,
    dsc.order_item_discount_rate,
    dsc.benefit_per_order,
    dsc.order_item_product_price,
    dsc.order_item_profit_ratio,
    dsc.order_item_quantity,
    dsc.order_item_total,
    dsc.sales_per_customer,
    dsc.sales,
    dsc.days_for_shipment_scheduled,
    dsc.days_for_shipping_real,
    dsc.late_delivery_risk,
    dsc.delivery_status

FROM staging.dataco_supplychain_stg AS dsc
LEFT JOIN core.dim_customer AS dc
    ON dsc.customer_id=dc.customer_id
LEFT JOIN core.dim_customer_location AS dcl
    ON dsc.customer_country=dcl.customer_country
    AND dsc.customer_state=dcl.customer_state
    AND dsc.customer_city=dcl.customer_city
    AND dsc.customer_zipcode=dcl.customer_zipcode
LEFT JOIN core.dim_order_location AS dol
    ON dsc.order_country=dol.order_country
    AND dsc.order_region=dol.order_region
    AND dsc.order_city=dol.order_city
    AND dsc.order_zipcode=dol.order_zipcode
LEFT JOIN core.dim_shipment AS dsp
    ON dsc.shipping_mode=dsp.shipping_mode
LEFT JOIN core.dim_product AS dpd
    ON dsc.product_card_id=dpd.product_card_id
LEFT JOIN core.dim_date AS odt 
    ON dsc.order_date_ts::date=odt.full_date
LEFT JOIN core.dim_date AS sdt
    ON dsc.shipping_date_ts::date=sdt.full_date
    