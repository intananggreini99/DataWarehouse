-- dim_product.sql  Transformasi 2 Dimensi Product

TRUNCATE TABLE dim_product RESTART IDENTITY CASCADE;
 
INSERT INTO dim_product (
    product_id, product_code, product_name, product_type,
    interest_rate, min_amount, max_amount, max_tenor_months
)
SELECT DISTINCT ON (product_id)
    product_id,
    product_code,
    product_name,
    product_type,
    product_interest_rate AS interest_rate,
    min_amount,
    max_amount,
    max_tenor_months
FROM stg.ods_loan_transactions
ORDER BY product_id;
 
SELECT COUNT(*) AS jumlah_product FROM dim_product;
