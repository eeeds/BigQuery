#standardSQL
#Desviación stándar y correlación
SELECT STDDEV(noemplyeesw3cnt) AS st_dev_employee_count,
CORR(totprgmrevnue, totfuncexpns) AS corr_rev_expenses
FROM `bigquery-public-data.irs_990.irs_990_2015`;

#Aproximación al contar
SELECT
APPROX_COUNT_DISTINCT(ein) as aprox_count,
COUNT(DISTINCT ein) as exact_count
FROM `bigquery-public-data.irs_990.irs_990_2015`;

--DESVIACIÓN STÁNDAR Y CORRELACIÓN
#standardSQL
SELECT STDDEV(noemplyeesw3cnt) AS st_dev_employee_count,
CORR(totprgmrevnue, totfuncexpns) AS corr_rev_expenses
FROM `bigquery-public-data.irs_990.irs_990_2015`;
--CUENTA APROX.
SELECT
APPROX_COUNT_DISTINCT(ein) as aprox_count,
COUNT(DISTINCT ein) as exact_count
FROM `bigquery-public-data.irs_990.irs_990_2015`;

#Approximate Users per Year of all github users
SELECT
    CONCAT('20', _TABLE_SUFFIX) year,
    APPROX_COUNT_DISTINCT(actor.login) approx_cnt
FROM `githubarchive.year.20*`
GROUP BY year
ORDER BY year

--CUENTA APROX LOG Y LUEGO MERGE PORQUE SE HIZO POR AÑO
WITH github_year_sketches AS (
    SELECT 
        CONCAT('20', _TABLE_SUFFIX) AS year,
        APPROX_COUNT_DISTINCT(actor.login) AS approx_cnt,
        HLL_COUNT.INIT(actor.login) AS sketch #HyperLogLog Estimation
    FROM `githubarchive.year.20*`
    GROUP BY year
    ORDER BY year
)

SELECT HLL_COUNT.MERGE(sketch) AS approx_unique_users
FROM `github_year_sketches`


--over partition

SELECT firstname, department, startdate
RANK() OVER (PARTITION BY department ORDER BY startdate) AS rank

FROM Employees


#Largest employer per U.S state for the 2015 filing year
WITH employees_count_per_state as (
SELECT ein, 
name,
noemplyeesw3cnt as number_of_employees,
state,
RANK() OVER (PARTITION BY state ORDER BY noemplyeesw3cnt DESC) AS rank 
FROM `bigquery-public-data.irs_990.irs_990_2015`
JOIN `bigquery-public-data.irs_990.irs_990_ein`
USING(ein)
GROUP BY 1,2,3,4
)

SELECT * FROM employees_count_per_state 
WHERE rank = 1
ORDER BY number_of_employees desc 
;