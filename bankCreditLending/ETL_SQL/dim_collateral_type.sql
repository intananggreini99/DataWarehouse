-- dim_collateral_type.sql : Transformasi 5 Dimensi Collateral Type
TRUNCATE TABLE dim_collateral_type RESTART IDENTITY CASCADE;
 
INSERT INTO dim_collateral_type (collateral_type_id, type_name, ltv_ratio)
SELECT DISTINCT ON (collateral_type_id)
    collateral_type_id,
    collateral_type_name AS type_name,  
    ltv_ratio
FROM stg.ods_loan_transactions
WHERE collateral_type_id IS NOT NULL     -- Filter rows
ORDER BY collateral_type_id;
 
SELECT COUNT(*) AS jumlah_collateral FROM dim_collateral_type;