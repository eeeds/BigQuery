#standardSQL
SELECT totrevenue
FROM `bigquery-public-data.irs_990.irs_990_2015`
ORDER BY totrevenue DESC 
LIMIT 10 

#Para formatear la respuesta:
SELECT FORMAT("%'d", totrevenue) AS revenue
FROM `bigquery-public-data.irs_990.irs_990_2015`
ORDER BY totrevenue DESC 
LIMIT 10


SELECT (totrevenue - totfuncexpns) AS income
FROM `bigquery-public-data.irs_990.irs_990_2015`
WHERE income>0#Aún no existe(dará error)
ORDER BY income DESC #Ya existe 
LIMIT 10

#standardSQL
SELECT
  SUM(totrevenue) AS total_2015_revenue,
  ROUND(AVG(totrevenue),2) AS avg_revenue,
  AVG(totrevenue) AS avg_revenue,
  COUNT(ein) AS nonprofits,
  COUNT(DISTINCT ein) AS nonprofits_distinct,
  MAX(noemplyeesw3cnt) AS num_employees
FROM
  `bigquery-public-data.irs_990.irs_990_2015`

--siempre poner un group by si se mezcan agregadas y no agregadas
SELECT
  ein, #not aggregated
  COUNT(ein) AS ein_count #aggregated, crea conflicto
FROM
  `bigquery-public-data.irs_990.irs_990_2015`
GROUP BY#Se usa para evitar el conflicto
  ein
HAVING ein_count>1
ORDER BY
  ein_count DESC


#standardSQL
SELECT 
ein,
tax_pd,
PARSE_DATE('%Y%m', CAST(tax_pd AS STRING)) AS tax_period
FROM `bigquery-public-data.irs_990.irs_990_2015`
WHERE 
EXTRACT(YEAR FROM PARSE_DATE('%Y%m', CAST(tax_pd AS STRING))
)= 2014
LIMIT 10


#standardSQL
SELECT
  ein,
  street,
  city,
  state,
  zip
FROM
  `bigquery-public-data.irs_990.irs_990_ein`
WHERE
  state IS NULL
LIMIT
  10;


  
  SELECT 
  ein,
  name
  FROM 
  `bigquery-public-data.irs_990.irs_990_ein`
  WHERE
  LOWER(name) LIKE '%help%'