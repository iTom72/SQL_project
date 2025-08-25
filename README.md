# Overview
Welcome to my Analysis of the data job market, focusing on data science roles. This project was made out of a desire to navigate and understand the job market more effectively. It delves into the top-paying and in-demand skills to find the most optimal oppotunities for data scientists.

> 📊 This dashboard was built as part of a YouTube tutorial by [Luke Barousse].  
> Data used in this project was provided in the original course and is used here for learning purposes.

# Background
The demand for data professionals is growing rapidly. However, the job market can be confusing, with different titles, skills, and salary ranges.
This project was created to get a clearer picture of what employers are looking for and which skills are worth to focus on.

### The questions I wanna to answer through my SQl queries are:
1. What are the top paying Data Science jobs?
2. What skills are required for these top-paying jobs?
3. What are the most in demand skills for Data Scientist?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I Used
**SQL:** to query and analyze the dataset.

**PostgreSQL:** as the database system for managing the data.

**Python(Pandas):** To visualize data.

# The Analysis

*All graphs are made using* [graphs_generator](graphs_generator.ipynb)

### 1. Top Paying Data Science Jobs
To indetify the highest-paying roles, I filtered Data Science postings by average yearly salary and location, focusing on remote jobs only. This query highlights the top-10 paying jobs.
```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    company_dim.name AS company_name
FROM
    job_postings_fact
LEFT JOIN
    company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Scientist' AND
    salary_year_avg IS NOT NULL AND
    job_location = 'Anywhere'
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```

#### Result
![1_top_paying_jobs](pics/1_top_paying_jobs.png)

## 2. Most Skills Associated With Highest Paid Jobs
To highlight the highest paid skills that are associated with top-paying jobs, I got the top-paying jobs's skills and filtered them by average yearly salary, company's name and the job title. This query shows the associated skills with the top-paying jobs.

```sql
WITH top_paying_jobs AS(
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        company_dim.name AS company_name
        
    FROM
        job_postings_fact
    LEFT JOIN
        company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Scientist' AND
        salary_year_avg IS NOT NULL AND
        job_location = 'Anywhere'
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)
SELECT top_paying_jobs.*,
    skills_dim.skills
FROM
    top_paying_jobs 
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON  skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    top_paying_jobs.salary_year_avg DESC;
```

### Reulst
![2_top_paying_jobs_skills](pics/2_top_paying_jobs_skills.png)

# 3.Most In-demand Skills For Data Science Job Postings
To identify the most in-demand skills for Data Science jobs, I highlighted the most in-demand skills and filtered them by the job title, job remote and the yearly salary. This query highlights the most in-demand skills for Data Science jobs.

```sql
WITH data_science_skills AS (
    SELECT
        skill_id, 
        COUNT (*) AS skill_count
    FROM
       skills_job_dim
    INNER JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
    WHERE
        job_postings_fact.job_title_short = 'Data Scientist'
        AND job_postings_fact.job_work_from_home IS TRUE
        AND job_postings_fact.salary_year_avg IS NOT NULL
    GROUP BY
        skill_id
)
SELECT
    skills_dim.skill_id,
    skills_dim.skills AS skill_name,
    data_science_skills.skill_count
FROM
    data_science_skills
INNER JOIN skills_dim ON data_science_skills.skill_id = skills_dim.skill_id
ORDER BY
    data_science_skills.skill_count DESC
LIMIT 10;
```

### Result
![3_most_demand_skills](pics/3_most_demand_skills.png)

# 4. Top-Paid Skills in Data Science Job Postings
To discover which skills are associated with higher salaries, I calculated the average yearly salary for each skill. This query highlights the top 10 best-paid skills that consistently appear in remote Data Science job postings.


```sql
SELECT
    skills_dim.skills AS skill_name,
    AVG(job_postings_fact.salary_year_avg)::INTEGER AS average_yearly_salary
FROM
    job_postings_fact
LEFT JOIN
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
LEFT JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.salary_year_avg IS NOT NULL
    AND job_postings_fact.job_title_short = 'Data Scientist'
    AND job_postings_fact.job_work_from_home IS TRUE
GROUP BY 
    skill_name
HAVING
    COUNT(skills_dim.skill_id) > 100
ORDER BY 
    average_yearly_salary DESC

LIMIT 10;
```


### Result
![4_top_paying_skills](pics/4_top_paying_skills.png)

# 5. Most Optimal Skill To Learn
To find the best skill to learn for Data Science role, I combined all of the previous queries to find the most optimal skill to learn, This combined query shows the most optimal skill to learn.
```sql
WITH top_paying_skills AS(
    SELECT
        skills_dim.skill_id AS skill_id,
        skills_dim.skills AS skill_name,
        AVG(job_postings_fact.salary_year_avg)::INTEGER AS average_yearly_salary
    FROM
        job_postings_fact
    LEFT JOIN
        skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    LEFT JOIN
        skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_postings_fact.salary_year_avg IS NOT NULL
         AND job_postings_fact.job_title_short = 'Data Scientist'
         AND job_postings_fact.job_work_from_home IS TRUE
    GROUP BY 
        skills_dim.skill_id
),

data_science_skills AS (
    SELECT
        skill_id, 
        COUNT (*) AS skill_count
    FROM
       skills_job_dim
    INNER JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
    WHERE
        job_postings_fact.job_title_short = 'Data Scientist'
        AND job_postings_fact.salary_year_avg IS NOT NULL
        AND job_postings_fact.job_work_from_home IS TRUE
    GROUP BY
        skill_id
),

most_demand_skills AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills AS skill_name,
        data_science_skills.skill_count AS skill_count
    FROM
        data_science_skills
    INNER JOIN skills_dim ON data_science_skills.skill_id = skills_dim.skill_id

)

SELECT
    most_demand_skills.skill_name,
    top_paying_skills.average_yearly_salary,
    most_demand_skills.skill_count
FROM
    most_demand_skills
INNER JOIN top_paying_skills ON most_demand_skills.skill_id = top_paying_skills.skill_id
WHERE
    most_demand_skills.skill_count > 100
ORDER BY
    top_paying_skills.average_yearly_salary DESC
    --most_demand_skills.skill_count DESC
```

### Result
![5_most_optimal_skill](pics/5_most_optimal_skill.png)

# What I Learned
Throughout this project, I enhanced my technical and analytical skills. Here are few specific things I learnedn:

- **What's SQL and DBMS:** I learned what's SQL and its kinds (Relational and non-Relational), and what's DMBS (Database Management Systems) mean and its subtypes like Postgres, MySQL, etc.

- **Basics Of SQL:** Such as creating, selecting, deleting tables, I also learned about making simple queries using things like SELECT, WHERE, ORDER BY, I learned using Aggregation Functions such as MAX, AVG, COUNT and filter it using HAVING etc.

- **Combining Many Result Sets:** I also learned how to combine Result Sets (Query Result) using all kinds of join like (INNER, LEFT, RIGHT etc.) and using UNION, UNION ALL.

# Challenges I Faced
This project wasn't without its challenges, but it provide good learning opportunities:
- **Understanding The Difference Between Relational and Non-Relational DBMS:** Knowing what's the different between those two different DMBS (Database Management Systems) wasn't easy it took some time but in the end i learnen what's the different between them and when to use each.
- **Combining Different Tables:** Combining two or more tables using JOIN wasn't an easy thing to learn especially knowing when to use each different JOIN (INNER, OUTER, LEFT, etc.), UNION is much clearer than JOIN but with enough practice I enhanced my skill to combine tables.

# Conclusion
This project gave me a clearer view of the Data Science job market and the skills that matter most. By combining salary insights with demand, I identified which skills are both valuable and rewarding for aspiring data scientists.