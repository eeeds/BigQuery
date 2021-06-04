#standardSQL
SELECT DISTINCT
  fullVisitorId,
  date,
  city,
  pageTitle
FROM `data-to-insights.ecommerce.all_sessions_raw`
WHERE date = '20170708'
LIMIT 5


#standardSQL
SELECT DISTINCT
  fullVisitorId,
  date,
  city,
  pageTitle
FROM `data-to-insights.ecommerce.all_sessions_raw`
WHERE date = '20180708'
LIMIT 5


/*
Scanning through the entire dataset everytime to compare rows against a WHERE condition is wasteful. 
This is especially true if you only really care about records for a specific period of time like:

All transactions for the last year
All visitor interactions within the last 7 days
All products sold in the last month
Instead of scanning the entire dataset and filtering on a date field like we did in the earlier queries,
 we will now setup a date-partitioned table. This will allow us to completely ignore scanning records in certain partitions 
 if they are irrelevant to our query.

*/

--PARTITION BY

#standardSQL
 CREATE OR REPLACE TABLE ecommerce.partition_by_day
 PARTITION BY date_formatted
 OPTIONS(
   description="a table partitioned by date"
 ) AS
 SELECT DISTINCT
 PARSE_DATE("%Y%m%d", date) AS date_formatted,
 fullvisitorId
 FROM `data-to-insights.ecommerce.all_sessions_raw`

 --AL PARTICIONAR Y TENER FECHAS DETERMINADAS SE TIENE UNA GRAN MEJORA DEL RENDIMIENTO
 --PARA LA PRIMERA QUERY SE TIENE UN PROCESAMIENTO SOLO DE 25KB MIENTRAS QUE EN EL SEGUNDO 0 MB DEBIDO A QUE 
 --AL PARTICIONAR NOS DAMOS CUENTA QUE NO EXISTEN VALORES PARA ESA FECHA

 --In this query, note the new option - PARTITION BY a field.
 -- The two options available to partition are DATE and TIMESTAMP.
 -- The PARSE_DATE function is used on the date field (stored as a string) to get it into the proper DATE type for partitioning.

  #standardSQL
SELECT *
FROM `data-to-insights.ecommerce.partition_by_day`
WHERE date_formatted = '2016-08-01'


#standardSQL
SELECT *
FROM `data-to-insights.ecommerce.partition_by_day`
WHERE date_formatted = '2018-07-08'

--EJERCICIO

#standardSQL
 CREATE OR REPLACE TABLE ecommerce.days_with_rain
 PARTITION BY date
 OPTIONS(
   description="weather stations with precipitation, partitioned by day",
    partition_expiration_days=60
 ) AS
 SELECT
   DATE(CAST(year AS INT64), CAST(mo AS INT64), CAST(da AS INT64)) AS date,
   (SELECT ANY_VALUE(name) FROM `bigquery-public-data.noaa_gsod.stations` AS stations
    WHERE stations.usaf = stn) AS station_name,  -- Stations may have multiple names
   prcp
 FROM `bigquery-public-data.noaa_gsod.gsod*` AS weather
 WHERE prcp < 99.9  -- Filter unknown values
   AND prcp > 0      -- Filter stations/days with no precipitation
   AND CAST(_TABLE_SUFFIX AS int64) >= 2018
/*
Confirm data partition expiration is working
To confirm you are only storing data from 60 days in the past up until today, 
run the DATE_DIFF query to get the age of your partitions, which are set to expire after 60 days.

*/

--prueba que solo toma 60 días
--Configuramos para que solo particione 60
#standardSQL
# avg monthly precipitation
SELECT
  AVG(prcp) AS average,
  station_name,
  date,
  CURRENT_DATE() AS today,
  DATE_DIFF(CURRENT_DATE(), date, DAY) AS partition_age,
  EXTRACT(MONTH FROM date) AS month
FROM ecommerce.days_with_rain
WHERE station_name = 'WAKAYAMA' #Japan
GROUP BY station_name, date, today, month, partition_age
ORDER BY date DESC; # most recent days first


--0tra prueba

#standardSQL
# avg monthly precipitation

SELECT
  AVG(prcp) AS average,
  station_name,
  date,
  CURRENT_DATE() AS today,
  DATE_DIFF(CURRENT_DATE(), date, DAY) AS partition_age,
  EXTRACT(MONTH FROM date) AS month
FROM ecommerce.days_with_rain
WHERE station_name = 'WAKAYAMA' #Japan
GROUP BY station_name, date, today, month, partition_age
ORDER BY partition_age DESC


