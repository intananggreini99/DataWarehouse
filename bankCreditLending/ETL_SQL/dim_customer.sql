-- dim_customer.sql  : Transformasi 1 Dimensi Customer

TRUNCATE TABLE dim_customer RESTART IDENTITY CASCADE;
 
INSERT INTO dim_customer (
    customer_id, national_id, full_name, date_of_birth, occupation,
    monthly_income, risk_segment, email, phone, credit_grade, bureau_source
)
SELECT DISTINCT ON (customer_id)
    customer_id,
    national_id,
    customer_name   AS full_name,        
    date_of_birth,
    occupation,
    monthly_income,
    risk_segment,
    email,
    phone,
    credit_grade,
    bureau_source
FROM stg.ods_loan_transactions
ORDER BY customer_id;
 
-- Verifikasi
SELECT COUNT(*) AS jumlah_customer FROM dim_customer;