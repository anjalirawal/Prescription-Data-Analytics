CREATE DATABASE final_assignment;
USE final_assignment;

ALTER TABLE fact_member_data
ADD PRIMARY KEY (mem_drug_id);

ALTER TABLE dim_drug
ADD PRIMARY KEY (mem_drug_id);

ALTER TABLE dim_prescription
ADD PRIMARY KEY (Prescription_id);

ALTER TABLE dim_drug
ADD CONSTRAINT fk_mem_drug_id
FOREIGN KEY (mem_drug_id)
REFERENCES fact_member_data(mem_drug_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE fact_member_data
ADD CONSTRAINT fk_mem_prescription_id
FOREIGN KEY (prescription_id)
REFERENCES dim_prescription(prescription_id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

# Part 4 
# Question: Write a SQL query that identifies the number of prescriptions grouped by drug name
SELECT dd.drug_name, COUNT(dp.prescription_id) AS number_of_prescriptions
FROM dim_prescription dp
JOIN dim_drug dd ON dp.mem_drug_id = dd.mem_drug_id
GROUP BY dd.drug_name
ORDER BY number_of_prescriptions DESC;

# a) Question: Also answer this question: How many prescriptions were filled for the drug Ambien?
SELECT dd.drug_name, COUNT(dp.prescription_id) AS number_of_prescriptions
FROM dim_prescription dp
JOIN dim_drug dd ON dp.mem_drug_id = dd.mem_drug_id
WHERE dd.drug_name = 'Ambien';

# b) Question: Write a SQL query that counts total prescriptions, counts unique (i.e. distinct) members, sums copay $$, and sums insurance paid $$, for members grouped as either ‘age 65+’ or ’ < 65’. Use case statement logic to develop this query 
SELECT 
    Age_Category,
    COUNT(DISTINCT fmd.member_id) AS Unique_Members,
    COUNT(dp.prescription_id) AS Total_Prescriptions,
    SUM(COALESCE(dp.copay1, 0) + COALESCE(dp.copay2, 0) + COALESCE(dp.copay3, 0)) AS Total_Copay,
    SUM(COALESCE(dp.insurancepaid1, 0) + COALESCE(dp.insurancepaid2, 0) + COALESCE(dp.insurancepaid3, 0)) AS Total_Insurance_Paid
FROM 
    (SELECT 
        member_id,
        prescription_id,
        CASE 
            WHEN member_age >= 65 THEN 'age 65+'
            ELSE '< 65'
        END AS Age_Category
    FROM fact_member_data) AS fmd
JOIN 
    dim_prescription dp ON fmd.prescription_id = dp.prescription_id
GROUP BY 
    Age_Category;

    
SELECT * FROM fact_member_data;

# a) Question: Also answer these questions: How many unique members are over 65 years of age?
SELECT 
    COUNT(DISTINCT member_id) AS Unique_Members_Over_65
FROM 
    fact_member_data
WHERE 
    member_age >= 65;

# b) Question: How many prescriptions did they fill?
SELECT 
    COUNT(dp.prescription_id) AS Total_Prescriptions_Filled_By_Over_65
FROM 
    fact_member_data fmd
JOIN 
    dim_prescription dp ON fmd.prescription_id = dp.prescription_id
WHERE 
    fmd.member_age >= 65;

#Question: Write a SQL query that identifies the amount paid by the insurance for the most recent prescription fill date. Use the format that we learned with SQL Window functions. Your output should be a table with member_id, member_first_name, member_last_name, drug_name, fill_date (most recent), and most recent insurance paid.
 SELECT
    member_id,
    member_first_name,
    member_last_name,
    drug_name,
    Most_Recent_Fill_Date,
    Most_Recent_Insurance_Paid
FROM (
    SELECT
        fmd.member_id,
        fmd.member_first_name,
        fmd.member_last_name,
        dd.drug_name,
        dp.fill_date1 AS Most_Recent_Fill_Date,
        dp.insurancepaid1 AS Most_Recent_Insurance_Paid,
        ROW_NUMBER() OVER (PARTITION BY fmd.member_id ORDER BY dp.fill_date1 DESC) AS rn
    FROM 
        fact_member_data fmd
    JOIN 
        dim_prescription dp ON fmd.prescription_id = dp.prescription_id
    JOIN
        dim_drug dd ON fmd.mem_drug_id = dd.mem_drug_id
) sub
WHERE 
    rn = 1;

#a) Question: For member ID 10003, what was the drug name listed on their most recent fill date?
SELECT
    member_id,
    drug_name,
    Most_Recent_Fill_Date
FROM (
    SELECT
        fmd.member_id,
        dd.drug_name,
        dp.fill_date1 AS Most_Recent_Fill_Date,
        ROW_NUMBER() OVER (PARTITION BY fmd.member_id ORDER BY dp.fill_date1 DESC) AS rn
    FROM 
        fact_member_data fmd
    JOIN 
        dim_prescription dp ON fmd.prescription_id = dp.prescription_id
    JOIN
        dim_drug dd ON fmd.mem_drug_id = dd.mem_drug_id
    WHERE 
        fmd.member_id = 10003  
) sub
WHERE 
    rn = 1; 
    
# b) Question: How much did their insurance pay for that medication?
SELECT
    member_id,
    drug_name,
    Most_Recent_Fill_Date,
    Most_Recent_Insurance_Paid
FROM (
    SELECT
        fmd.member_id,
        dd.drug_name,
        dp.fill_date1 AS Most_Recent_Fill_Date,
        dp.insurancepaid1 AS Most_Recent_Insurance_Paid,
        ROW_NUMBER() OVER (PARTITION BY fmd.member_id ORDER BY dp.fill_date1 DESC) AS rn
    FROM 
        fact_member_data fmd
    JOIN 
        dim_prescription dp ON fmd.prescription_id = dp.prescription_id
    JOIN
        dim_drug dd ON fmd.mem_drug_id = dd.mem_drug_id
    WHERE 
        fmd.member_id = 10003  
) sub
WHERE 
    rn = 1; 

