/*
Question: What are the top-paying data analyst jobs?
- Identify the top 10 highest-paying Data Analyst roles that are available remotely or in Kitchener, Waterloo, Great Toronto Area.
- Focuses on job postings with specified salaries (remove nulls).
- Why? Highlight the top-paying opportunities for Data Analysts, offering insights into employment opportunities.
*/

SELECT 
    job_id,
     name AS company_name,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
   

FROM 
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id


WHERE 
     job_title_short = 'Data Analyst'
    AND
     job_location IN ('Anywhere','Waterloo, ON, Canada', 'Kitchener, ON, Canada', 'Toronto, ON, Canada')
    AND salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC
LIMIT 10;

