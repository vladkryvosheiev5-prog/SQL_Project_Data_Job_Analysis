/*
Answer: What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries),
    offering strategic insights for career development in data analysis
*/


--3
WITH skills_demand AS(
SELECT 
    skills_dim.skill_id,
    skills_dim.skills, 
    COUNT(skills_job_dim.job_id) AS demand_count

FROM job_postings_fact

INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

WHERE   
job_location IN ('Kitchener, ON, Canada', 'Waterloo, ON, Canada', 'Toronto, ON, Canada', 'Anywhere' ) AND 
job_title_short IN ('Data Analyst', 'Data Scientist')
AND salary_year_avg IS NOT NULL  

GROUP BY skills_dim.skill_id

), skill_salary AS (


SELECT 
    skills_dim.skill_id,
    ROUND(AVG(salary_year_avg), 0) AS salary_per_skill,
    job_title_short

FROM job_postings_fact


INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

WHERE 
    job_location IN ('Kitchener, ON, Canada', 'Waterloo, ON, Canada', 'Toronto, ON, Canada', 'Anywhere' ) AND 
    salary_year_avg IS NOT NULL 
    AND job_title_short IN ('Data Analyst','Data Scientist')


GROUP BY 
    skills_dim.skill_id,
    job_title_short
)

SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    salary_per_skill,
    job_title_short

FROM 
    skills_demand
INNER JOIN skill_salary ON skills_demand.skill_id = skill_salary.skill_id
ORDER BY   
    demand_count DESC,
    salary_per_skill DESC
LIMIT 25