-- dim_branch.sql : Transformasi 3 Dimensi Branch
TRUNCATE TABLE dim_branch RESTART IDENTITY CASCADE;
 
INSERT INTO dim_branch (
    branch_id, branch_code, branch_name, city, region, opened_date
)
SELECT DISTINCT ON (branch_id)
    branch_id,
    branch_code,
    branch_name,
    city,
    region,
    branch_opened_date AS opened_date  
FROM stg.ods_loan_transactions
ORDER BY branch_id;
 
SELECT COUNT(*) AS jumlah_branch FROM dim_branch;