```mermaid
erDiagram
    dim_customer {
        int customer_key PK
        int customer_id
        string customer_fname
        string customer_lname
        string customer_segment
    }

    dim_customer_location {
        int location_key PK
        string customer_country
        string customer_state
        string customer_city
        string customer_zipcode
        numeric latitude
        numeric longitude
    }
    dim_order_location {
        int order_location_key PK
        string order_country
        string order_region
        string order_city
        string order_zipcode
        string market
    }
    dim_category {
        int category_key PK
        int category_id
        string category_name
        string department_id
        string department_name
    }
    dim_shipment  {
        int shipment_key PK
        string shipping_mode
    }
    dim_products {
        int product_key PK
        int product_card_id
        int product_category_id
        string product_name
        int product_price
        product_status
    }
    dim_date {
        int date_key PK
        int full_date
        boolean is_weekend
        int day_of_month
        int day_of_month
        int month
        string month_name
        int quarter
        int year
    }
    fact_order_item {
        int order_item_id PK
        int order_id
        int customer_key FK
        int location_key FK
        int shipment_key FK
        int product_key FK
        int date_key FK
        


    }
```