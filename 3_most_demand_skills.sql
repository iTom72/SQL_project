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