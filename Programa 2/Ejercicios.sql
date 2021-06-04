#Hace unión de todas esas tablas en una sola
#standardSQL

SELECT 
stn,
wban,
temp,
year
FROM `bigquery-public-data.noaa_gsod.gsod*`

WHERE _TABLE_SUFFIX>'1999'

LIMIT 10;

#Buscando errores en los datos
#standardSQL

SELECT 
stn,
wban,
temp,
year,
_TABLE_SUFFIX AS TABLE_YEAR
FROM `bigquery-public-data.noaa_gsod.gsod*`

WHERE _TABLE_SUFFIX<>year

LIMIT 10;

--join

#standardSQL

SELECT 
a.stn ,
a.wban,
a.temp,
a.year,
b.name,
b.state,
b.country

FROM `bigquery-public-data.noaa_gsod.gsod*` AS a
JOIN `bigquery-public-data.noaa_gsod.stations` AS b
ON

a.stn = b.usaf
AND a.wban = b.wban