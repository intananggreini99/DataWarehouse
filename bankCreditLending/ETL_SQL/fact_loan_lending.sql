-- fact_loan_lending.sql : Transformasi 9 Fact Loan Lending

TRUNCATE TABLE fact_loan_lending RESTART IDENTITY CASCADE;
 
INSERT INTO fact_loan_lending (
    sk_customer, sk_product, sk_branch, sk_employee, sk_collateral_type,
    sk_date_application, sk_date_approval, sk_date_disbursement,
    application_id, approval_id, disbursement_id, assessment_id, pledge_id,
    app_status,
    requested_amount, approved_amount, disbursed_amount,
    tenor_months, final_rate, dti_ratio, pd_score, credit_score,
    appraised_value
)
SELECT
    dc.sk_customer,                                  -- Stream Lookup sk_customer
    dp.sk_product,                                   -- Stream Lookup sk_product
    db.sk_branch,                                    -- Stream Lookup sk_branch
    de.sk_employee,                                  -- Stream Lookup sk_employee
    dct.sk_collateral_type,                          -- Stream Lookup sk_collateral_type
    dd_app.sk_date  AS sk_date_application,          -- Stream Lookup sk_date_application
    dd_apr.sk_date  AS sk_date_approval,             -- Stream Lookup sk_date_approval
    dd_dis.sk_date  AS sk_date_disbursement,         -- Stream Lookup sk_date_disbursement
    o.application_id,
    o.approval_id,
    o.disbursement_id,
    o.assessment_id,
    o.pledge_id,
    o.app_status,
    o.requested_amount,
    o.approved_amount,
    o.disbursed_amount,
    o.tenor_months,
    o.final_rate,
    o.dti_ratio,
    o.pd_score,
    o.credit_score,
    o.appraised_value
FROM  stg.ods_loan_transactions   o
LEFT JOIN dim_customer        dc     ON o.customer_id        = dc.customer_id
LEFT JOIN dim_product         dp     ON o.product_id         = dp.product_id
LEFT JOIN dim_branch          db     ON o.branch_id          = db.branch_id
LEFT JOIN dim_employee        de     ON o.approver_id        = de.employee_id
LEFT JOIN dim_collateral_type dct    ON o.collateral_type_id = dct.collateral_type_id
LEFT JOIN dim_date            dd_app ON o.application_date   = dd_app.full_date
LEFT JOIN dim_date            dd_apr ON o.approval_date      = dd_apr.full_date
LEFT JOIN dim_date            dd_dis ON o.disbursed_on       = dd_dis.full_date
ORDER BY o.application_id;
 
SELECT COUNT(*) AS jumlah_fact_lending FROM fact_loan_lending;
