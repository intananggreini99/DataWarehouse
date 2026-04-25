-- dim_application_status.sql : Transformasi 8 Dimensi Application Status
TRUNCATE TABLE dim_application_status RESTART IDENTITY CASCADE;
 
INSERT INTO dim_application_status (app_status_code, app_status_desc)
SELECT DISTINCT
    app_status AS app_status_code,
    app_status AS app_status_desc
FROM stg.ods_loan_transactions
WHERE app_status IS NOT NULL
ORDER BY app_status;
 
SELECT * FROM dim_application_status ORDER BY sk_app_status;
