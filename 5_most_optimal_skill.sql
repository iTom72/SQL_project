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
        job_postings_fact.salary_year_avg IS NOT NULL AND job_postings_fact.job_title_short = 'Data Scientist'
    GROUP BY 
        skills_dim.skill_id
    HAVING
        COUNT(skills_dim.skill_id) > 100
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
    most_demand_skills.skill_id,
    most_demand_skills.skill_name,
    top_paying_skills.average_yearly_salary,
    most_demand_skills.skill_count
FROM
    most_demand_skills
INNER JOIN top_paying_skills ON most_demand_skills.skill_id = top_paying_skills.skill_id
WHERE
    most_demand_skills.skill_count > 100 -- Filtering low demand skills
ORDER BY
--    most_demand_skills.skill_count DESC
    top_paying_skills.average_yearly_salary DESC

