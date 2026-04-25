-- dim_payment_status.sql : Transformasi 7 Dimensi Payment Status
TRUNCATE TABLE dim_payment_status RESTART IDENTITY CASCADE;
 
INSERT INTO dim_payment_status (status_code, status_desc)
SELECT DISTINCT
    payment_status AS status_code,
    CASE payment_status
        WHEN 'Paid'    THEN 'Lunas'
        WHEN 'Pending' THEN 'Belum Bayar'
        WHEN 'Overdue' THEN 'Tertunggak'
        WHEN 'Partial' THEN 'Bayar Sebagian'
        ELSE payment_status
    END AS status_desc
FROM stg.ods_loan_payments
WHERE payment_status IS NOT NULL
ORDER BY payment_status;
 
SELECT * FROM dim_payment_status ORDER BY sk_payment_status;