-- dim_date.sql : Transformasi 6 Dimensi Date
TRUNCATE TABLE dim_date RESTART IDENTITY CASCADE;
 
INSERT INTO dim_date (
    full_date, day, day_name, week, month, month_name,
    quarter, year, is_weekend
)
SELECT
    d.dt                                          AS full_date,
    EXTRACT(DAY     FROM d.dt)::INT               AS day,
    TRIM(TO_CHAR(d.dt, 'Day'))                    AS day_name,
    EXTRACT(WEEK    FROM d.dt)::INT               AS week,
    EXTRACT(MONTH   FROM d.dt)::INT               AS month,
    TRIM(TO_CHAR(d.dt, 'Month'))                  AS month_name,
    EXTRACT(QUARTER FROM d.dt)::INT               AS quarter,
    EXTRACT(YEAR    FROM d.dt)::INT               AS year,
    (EXTRACT(DOW FROM d.dt) IN (0, 6))            AS is_weekend
FROM (
    SELECT application_date   AS dt FROM stg.ods_loan_transactions 
        WHERE application_date  IS NOT NULL
    UNION
    SELECT approval_date           FROM stg.ods_loan_transactions 
        WHERE approval_date     IS NOT NULL
    UNION
    SELECT disbursed_on            FROM stg.ods_loan_transactions 
        WHERE disbursed_on      IS NOT NULL
    UNION
    SELECT assessed_on             FROM stg.ods_loan_transactions 
        WHERE assessed_on       IS NOT NULL
    UNION
    SELECT pledge_date             FROM stg.ods_loan_transactions 
        WHERE pledge_date       IS NOT NULL
    UNION
    SELECT rating_date             FROM stg.ods_loan_transactions 
        WHERE rating_date       IS NOT NULL
    UNION
    SELECT due_date                FROM stg.ods_loan_payments     
        WHERE due_date          IS NOT NULL
    UNION
    SELECT paid_date               FROM stg.ods_loan_payments     
        WHERE paid_date         IS NOT NULL
) d
ORDER BY d.dt;
 
SELECT COUNT(*) AS jumlah_tanggal FROM dim_date;
