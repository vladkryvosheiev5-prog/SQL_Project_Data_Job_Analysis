/*
Question: What skills are required for the top-paying data analyst jobs?
- Use the top 10 highest-paying Data Analyst jobs from first query
- Add the specific skills required for these roles
- Why? It provides a detailed look at which high-paying jobs demand certain skills,
  helping job seekers understand which skills to develop that align with top salaries
*/


WITH top_paying_jobs AS (
   ( SELECT 
        job_id,
        name AS company_name,
        job_title,
        job_location,
        salary_year_avg
        
    

    FROM 
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
   
   
WHERE job_title_short = 'Data Analyst' 
        AND
        job_location IN ('Anywhere','Waterloo, ON, Canada', 'Kitchener, ON, Canada', 'Toronto, ON, Canada')
AND salary_year_avg IS NOT NULL
AND EXISTS (SELECT 1 FROM skills_job_dim WHERE skills_job_dim.job_id = job_postings_fact.job_id)

   

ORDER BY 
        salary_year_avg DESC
    LIMIT 5
)


UNION


(
    SELECT 
        job_id,
        name AS company_name,
        job_title,
        job_location,
        salary_year_avg
            
        

        FROM 
            job_postings_fact
        LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
        
    
    WHERE job_title_short = 'Data Scientist' 
    AND
        job_location IN ('Anywhere','Waterloo, ON, Canada', 'Kitchener, ON, Canada', 'Toronto, ON, Canada')
    AND salary_year_avg IS NOT NULL 
    AND EXISTS (SELECT 1 FROM skills_job_dim WHERE skills_job_dim.job_id = job_postings_fact.job_id)



    ORDER BY 
        salary_year_avg DESC
        LIMIT 5
)
)




SELECT top_paying_jobs.*,
skills
   

FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

ORDER BY 
        salary_year_avg DESC


