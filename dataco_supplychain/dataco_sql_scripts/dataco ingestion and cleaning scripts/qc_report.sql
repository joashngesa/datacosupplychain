--DATA QUALITY CHECK
--Final output expected returns:
    --check_name
    --issue_count
    --status
--the data should check:
    --null_customer_key✅
    --null_product_key✅
    --duplicate_order_item_id✅
    --orphan_product_key✅
    --orphan_customer_key✅
    --orphan_shipment_key✅
--status rule:
    --issue_count = 0 → PASS
    --issue_count > 0 → FAIL


WITH report AS (
        SELECT
            'null_customer_key' as check_issue,
            count(*) as issue_counts
        FROM core.fact_order_item
        WHERE customer_key is NULL

        UNION ALL

        SELECT
            'null_product_key' as check_issue,
            count(*) as issue_counts
        FROM core.fact_order_item
        WHERE product_key is NULL

        UNION ALL

        SELECT
            'duplicate_order_item_id' AS check_issue,
            count(*) as issue_counts
        FROM (
                SELECT
                    order_item_id,
                    count(*)
                FROM core.fact_order_item
                GROUP BY order_item_id
                HAVING count(*) > 1
        ) duplicates

        UNION ALL

        SELECT
            'orphan_customer_key' AS check_issue,
            count(*) as issue_counts
        FROM core.fact_order_item as foi
        LEFT JOIN core.dim_customer as dc
        ON foi.customer_key = dc.customer_key
        WHERE dc.customer_key is NULL
        
        UNION ALL

        SELECT
            'orphan_product_key' AS check_issue,
            count(*) as issue_counts
        FROM core.fact_order_item AS foi   
        LEFT JOIN core.dim_product as dp
        ON foi.product_key = dp.product_key
        WHERE dp.product_key is NULL

        UNION ALL

        SELECT
            'orphan_shipment_key' AS check_issue,
            count(*) AS issue_counts
        FROM core.fact_order_item AS foi
        LEFT JOIN core.dim_shipment AS ds
        ON foi.shipment_key = ds.shipment_key
        WHERE ds.shipment_key is NULL
)
--status rule:
    --issue_count = 0 → PASS
    --issue_count > 0 → FAIL
SELECT
    check_issue,
    issue_counts,
    CASE
        WHEN issue_counts = 0 THEN 'pass'
        ELSE 'fail'
        END AS status
    FROM report
