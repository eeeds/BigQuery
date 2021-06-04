#Union

#standardSQL
SELECT

COUNT(*) AS number_of_filings,
_TABLE_SUFFIX  AS year_filed
FROM `bigquery-public-data.irs_990.irs_990*`
GROUP BY year_filed
ORDER BY year_filed;

#FORMAT YYYY
#standardSQL
# UNION Wildcard and returning a table suffix
SELECT
  COUNT(*) as number_of_filings,
  CONCAT("2",_TABLE_SUFFIX) AS year_filed
FROM `bigquery-public-data.irs_990.irs_990_2*`
GROUP BY year_filed
ORDER BY year_filed DESC

/*
Lastly, modify your query to only include tax filings from tables on or after 2013. Also include average totrevenue and average totfuncexpns as additional metrics.

Hint: Consider using _TABLE_SUFFIX in a filter.
*/
#standardSQL
# UNION Wildcard and returning a table suffix
SELECT
  COUNT(ein) as nonprofit_count,
  AVG(totrevenue) AS AVGREVENUE,
  AVG(totfuncexpns) AS AVGFUNCEXPNS,
  CONCAT("20",_TABLE_SUFFIX) AS year_filed
FROM `bigquery-public-data.irs_990.irs_990_20*`
WHERE _TABLE_SUFFIX>='13'
GROUP BY year_filed
ORDER BY year_filed DESC

--join


#standard SQL
  # Find the Org Names of all EINs for 2015 with some revenue or expenses, limit 100
SELECT
  tax.ein AS tax_ein,
  org.ein AS org_ein,
  org.name,
  tax.totrevenue,
  tax.totfuncexpns
FROM `bigquery-public-data.irs_990.irs_990_2015`
  AS tax
JOIN `bigquery-public-data.irs_990.irs_990_ein`
  AS org
ON
  tax.ein =org.ein
WHERE
 tax.totrevenue > 0 or tax.totfuncexpns >0
LIMIT
  100;



  #standardSQL
  # Find where tax records exist for 2015 but no corresponding Org Name
SELECT
  tax.ein AS tax_ein,
  org.ein AS org_ein,
  org.name,
  tax.totrevenue,
  tax.totfuncexpns
FROM
  `bigquery-public-data.irs_990.irs_990_2015` tax
FULL JOIN  # Complete the JOIN
  `bigquery-public-data.irs_990.irs_990_ein` org
ON tax.ein = org.ein

WHERE 
org.ein  IS NULL # put tax.ein or org.ein to check here (one is correct)