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
    job_postings_fact.salary_year_avg IS NOT NULL AND job_postings_fact.job_title_short = 'Data Scientist'
GROUP BY 
    skill_name
HAVING
    COUNT(skills_dim.skill_id) > 100
ORDER BY 
    average_yearly_salary DESC

LIMIT 10;
