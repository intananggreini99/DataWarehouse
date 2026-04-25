-- fact_loan_payment.sql : Transformasi 10 Fact Loan Payment
TRUNCATE TABLE fact_loan_payment RESTART IDENTITY CASCADE;
 
INSERT INTO fact_loan_payment (
    sk_loan_fact, sk_customer, sk_payment_status,
    sk_date_paid, sk_date_due,
    principal, interest, total_paid, days_late
)
SELECT
    flf.sk_loan_fact,                              -- Stream Lookup sk_loan_fact
    dc.sk_customer,                                -- Stream Lookup sk_customer
    dps.sk_payment_status,                         -- Stream Lookup sk_payment_status
    dd_paid.sk_date AS sk_date_paid,               -- Stream Lookup sk_date_paid
    dd_due.sk_date  AS sk_date_due,                -- Stream Lookup sk_date_due
    p.principal,
    p.interest,
    (p.principal + p.interest)          AS total_paid,   -- Calculator
    CASE 
        WHEN p.paid_date IS NULL THEN NULL
        ELSE (p.paid_date - p.due_date)
    END                                 AS days_late     -- Calculator (nullable)
FROM  stg.ods_loan_payments  p
LEFT JOIN fact_loan_lending   flf      ON p.application_id  = flf.application_id
LEFT JOIN dim_customer        dc       ON p.customer_id     = dc.customer_id
LEFT JOIN dim_payment_status  dps      ON p.payment_status  = dps.status_code
LEFT JOIN dim_date            dd_paid  ON p.paid_date       = dd_paid.full_date
LEFT JOIN dim_date            dd_due   ON p.due_date        = dd_due.full_date
ORDER BY p.payment_id;
 
SELECT COUNT(*) AS jumlah_fact_payment FROM fact_loan_payment;
