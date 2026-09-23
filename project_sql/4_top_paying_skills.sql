/*
Answer: What are the top skills based on salary?
- Look at the average salary associated with each skill for Data Analyst positions
- Focuses on roles with specified salaries, regardless of location
- Why? It reveals how different skills impact salary levels for Data Analysts and
    helps identify the most financially rewarding skills to acquire or improve
*/

SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS salary_per_skill,
    job_title_short

FROM job_postings_fact


INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

WHERE 
    job_location IN ('Kitchener, ON, Canada', 'Waterloo, ON, Canada', 'Toronto, ON, Canada', 'Anywhere' ) AND 
    salary_year_avg IS NOT NULL AND 
    job_title_short IN ('Data Analyst','Data Scientist')


GROUP BY 
    skills,
    job_title_short

ORDER BY
    salary_per_skill DESC

LIMIT 25


/*
Specialized skills pay more

The highest-paying skills are generally more specialized and technical than the standard Data Analyst toolkit. 
Skills like Golang, PySpark, Rust, Cassandra, DynamoDB, and Neo4j are associated with roles involving programming, 
large-scale data processing, and data infrastructure.


Data Science dominates

Most of the top 25 skills are associated with Data Scientist positions rather than Data Analyst positions. 
This suggests that the very highest-paying data roles tend to require a broader technical skill set 
than traditional analyst roles.


Engineering + analytics

A major trend is the overlap between data analytics and software/data engineering. 
Skills such as PySpark, distributed databases, and programming languages appear alongside analytics and BI tools. 
This suggests that developing engineering-related skills can open pathways toward higher-paying data roles.


Overall takeaway

SQL and Python remain important foundational skills, but the highest-paying roles increasingly combine analytics with specialized programming, big-data processing, and data infrastructure skills.*/
