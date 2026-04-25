-- dim_employee.sql : Transformasi 4 Dimensi Employee
TRUNCATE TABLE dim_employee RESTART IDENTITY CASCADE;
 
INSERT INTO dim_employee (employee_id, full_name, role)
SELECT DISTINCT ON (approver_id)
    approver_id    AS employee_id,       
    approver_name  AS full_name,         
    approver_role  AS role               
FROM stg.ods_loan_transactions
WHERE approver_id IS NOT NULL
ORDER BY approver_id;
 
SELECT COUNT(*) AS jumlah_employee FROM dim_employee;
