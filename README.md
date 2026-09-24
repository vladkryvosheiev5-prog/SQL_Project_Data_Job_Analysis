# Introduction
Dive into the data job market! This project focuses on Data Analyst and Data Scientist roles, exploring 💰 top-paying jobs, 🔥 in-demand skills, and 📈 where high demand meets high salary in data careers — with a specific look at remote roles and opportunities in the Waterloo, Kitchener, and Toronto, Ontario area.

SQL queries? Check them out here: [project_sql folder](/project_sql/)

# Background
This project was built while working through Luke Barousse's SQL for Data Analytics course, using his 2023 job postings dataset. Rather than just repeating the course's exact queries, I adapted them to compare Data Analyst and Data Scientist roles side by side, and to answer a question that mattered to me personally: how do remote opportunities compare to jobs in my local area (Waterloo, ON / Kitchener, ON / Toronto, ON)?

The data comes from [Luke Barousse's SQL Course](https://lukebarousse.com/sql), packed with details on job titles, salaries, locations, and required skills.

### The questions I wanted to answer through my SQL queries were:
1. What are the top-paying Data Analyst and Data Scientist jobs (remote and in the Waterloo/Kitchener/Toronto area)?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for these roles overall?
4. Which skills are associated with the highest salaries?
5. What are the most optimal skills to learn (a balance of high demand and high pay)?

# Tools I Used
For my deep dive into the data job market, I used several key tools:

- **SQL:** The backbone of my analysis, used to query the database and pull out critical insights.
- **PostgreSQL:** The chosen database management system, well suited for handling the job posting data.
- **Visual Studio Code:** My go-to for database management and writing/executing SQL queries.
- **Git & GitHub:** Essential for version control and sharing my SQL scripts and analysis.

# The Analysis
Each query in this project investigated a specific part of the data job market. Here's how I approached each question:

### 1. Top Paying Jobs
To identify the highest-paying roles, I filtered Data Analyst and Data Scientist positions by average yearly salary and location (Anywhere, or the Waterloo/Kitchener/Toronto area), keeping only postings with a specified salary.

```sql
SELECT
    job_id,
    name AS company_name,
    job_title,
    job_location,
    salary_year_avg
FROM job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    (job_title_short = 'Data Analyst' OR job_title_short = 'Data Scientist')
    AND job_location IN ('Anywhere', 'Waterloo, ON, Canada', 'Kitchener, ON, Canada', 'Toronto, ON, Canada')
    AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;
```

Here's a breakdown of the top-paying jobs:
- **Wide salary range:** The top 10 roles span from $184,000 to $650,000, showing just how much earning potential exists in data roles.
- **Remote-heavy:** Nearly all of the highest-paying postings that met the salary/location criteria were listed as "Anywhere," reflecting how much high-paying data work has shifted remote.
- **Job title variety:** Titles ranged from "Data Analyst" to "Director of Analytics" and "Associate Director - Data Insights," showing that the ceiling for a data career extends well past the entry-level title.

### 2. Skills for Top-Paying Jobs
Joining the top-paying jobs with skills data revealed which specific skills these high-salary postings actually asked for.

```sql
SELECT
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC;
```

Here's what stood out among skills tied to the highest salaries:
- **SQL and Python dominate:** Both appear repeatedly across the highest-paying postings, reinforcing them as the foundation of a data career, regardless of specialization.
- **Specialized/big-data tools carry weight at the top:** Skills like Spark, Cassandra, and Hadoop show up on some of the very highest-paying postings, hinting that big-data infrastructure knowledge pushes salaries even higher.
- **Cloud and BI tools appear too:** AWS, Azure, and Tableau show up on multiple top listings, suggesting cloud fluency and visualization ability both add value at the senior/director level.

### 3. In-Demand Skills
This query counted how often each skill appeared across all job postings to find what's most frequently requested.

```sql
SELECT
    skills,
    COUNT(job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5;
```

| Skill   | Demand Count |
|---------|-------------|
| SQL     | 14,946      |
| Python  | 14,881      |
| R       | 6,878       |
| Tableau | 6,265       |
| Excel   | 5,915       |

SQL and Python are essentially tied at the top and far ahead of everything else, confirming they're the two non-negotiable skills across the data job market as a whole — with R, Tableau, and Excel forming a clear second tier.

### 4. Skills Based on Salary
Looking at average salary per skill (broken out by Data Analyst vs. Data Scientist) surfaced which specific, often niche, skills are tied to the biggest paychecks.

```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg), 0) AS salary_per_skill,
    job_title_short
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE salary_year_avg IS NOT NULL
GROUP BY skills, job_title_short
ORDER BY salary_per_skill DESC
LIMIT 25;
```

Highlights:
- **Niche/compliance and specialized engineering skills top the list:** GDPR ($217,738) and Golang ($208,750) led all Data Scientist postings, while PySpark ($208,172) topped the Data Analyst list — none of these are "core" skills, but they command a premium exactly because so few candidates have them.
- **Big-data and ML-adjacent tools cluster near the top for Data Scientists:** Atlassian, Selenium, OpenCV, Neo4j, and DataRobot all appear in the upper range for Data Scientist salaries, pointing toward engineering/ML-adjacent skills paying more than "pure analytics" ones.
- **Even for Data Analysts, engineering skills pay more:** PySpark and Bitbucket — both more engineering-flavored than the typical analyst toolkit — topped the Data Analyst salary list, suggesting analysts who can straddle into engineering territory earn more.

### 5. Most Optimal Skills to Learn
Combining demand and average salary for each skill (split by Data Analyst vs. Data Scientist) pointed toward the skills that are simultaneously in high demand *and* well paid — the best return on time invested learning them.

```sql
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS salary_per_skill,
    job_postings_fact.job_title_short
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE salary_year_avg IS NOT NULL
GROUP BY skills_dim.skill_id, job_postings_fact.job_title_short
ORDER BY demand_count DESC, salary_per_skill DESC;
```

| Skill    | Demand Count | Avg Salary (Data Scientist) | Avg Salary (Data Analyst) |
|----------|-------------|------------------------------|----------------------------|
| Python   | 1,011       | $143,500                     | $101,397                   |
| SQL      | 999         | $142,465                     | $97,237                    |
| R        | 546         | $137,850                     | $100,499                   |
| Tableau  | 451         | $146,500                     | $99,288                    |
| Excel    | 335         | $129,587                     | $87,194                    |
| AWS      | 251         | $149,085                     | $108,317                   |
| Power BI | 183         | $130,823                     | $97,431                    |

- **The same handful of skills anchor both roles:** Python, SQL, R, Tableau, and Excel show up as the highest-demand skills for both Data Analysts and Data Scientists — there's no shortcut around learning them.
- **The Data Scientist "premium" is consistent:** For every single skill in this table, the average Data Scientist salary is meaningfully higher than the average Data Analyst salary for that same skill — often by $30,000–$45,000 — suggesting the title/scope of the role matters as much as the specific tool.
- **AWS stands out:** Even at a lower demand count than SQL/Python, AWS carries some of the highest average salaries for both roles, making cloud skills a strong "second skill" to layer on top of the SQL/Python foundation.

# What I Learned
Through this project, I strengthened several core SQL skills:

- 🧩 **Complex query construction:** Combining multiple `JOIN`s, CTEs, and `UNION` to answer multi-part questions in a single query.
- 📊 **Data aggregation:** Getting comfortable with `GROUP BY`, `COUNT()`, and `AVG()` to turn raw rows into summarized insights.
- 💡 **Debugging real logic bugs:** Learning firsthand how operator precedence (`AND` binding tighter than `OR`), `INNER JOIN` vs. `LEFT JOIN`, and `GROUP BY` rules can silently produce wrong — not broken — results if you're not careful.
- 🔧 **Real-world SQL problem-solving:** Turning open-ended questions into effective, accurate queries, and verifying results rather than assuming a query that "runs" is a query that's "right."

# Conclusions

### Insights
From the analysis, several general insights emerged:
1. **Top-paying data jobs skew remote.** The highest salaries in the dataset were overwhelmingly tied to "Anywhere" postings rather than any single physical location.
2. **SQL and Python are non-negotiable.** They dominate both the "most in-demand" and "most optimal" skill lists — no path through this market skips them.
3. **Specialized skills reward risk-taking.** Skills like GDPR, Golang, and PySpark, while less common, are tied to some of the highest average salaries — indicating real financial upside to developing a niche alongside the fundamentals.
4. **Data Scientist roles consistently out-earn Data Analyst roles for the same skill set** — the same tools are worth more attached to a different job title, which says as much about scope/seniority expectations as it does about the tools themselves.
5. **The "optimal" skills are the obvious ones.** Python, SQL, R, Tableau, and Excel aren't just popular — they're the actual sweet spot of demand and pay, which is reassuring for anyone building a learning roadmap.

### Closing Thoughts
This project both reinforced my SQL fundamentals and gave me a genuinely useful lens on the data job market — especially in comparing what's possible remotely versus locally in the Waterloo/Kitchener/Toronto corridor. Beyond the specific findings, this project was valuable practice in translating open-ended business questions into precise, correct SQL — and in learning to verify a query's logic rather than just its output.
