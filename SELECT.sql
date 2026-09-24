SELECT 
    salary_year_avg,
    job_id,
    CASE
    
        WHEN salary_year_avg < 50000 THEN 'Low Salary'
        WHEN salary_year_avg BETWEEN 50000 AND 100000 THEN 'Medium Salary'
        WHEN salary_year_avg IS NULL THEN 'No Salary Data'
        ELSE 'High Salary'

    END AS salary_by_job
FROM 
    job_postings_fact

WHERE
    salary_year_avg IS NOT NULL
    AND job_title_short = 'Data Analyst'
ORDER BY
    salary_year_avg DESC;




