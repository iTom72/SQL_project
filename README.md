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
![top_paying_jobs](pics/1_top_paying_jobs.png)


## 2. Most Skills Associated With Highest Paid Jobs
To highlight the highest paid skills that are associated with top-paying jobs, I got the top-paying jobs's skills and filtered them by average yearly salary, company's name and the job title. This query shows the associated skills with the top-paying jobs.

```
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


### Reulsts
![top_paying_jobs_skills](pics/2_top_paying_jobs_skills.png)

# What I Learned

# Conclusion