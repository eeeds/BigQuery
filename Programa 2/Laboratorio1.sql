/*Rules for creating tables with SQL in BigQuery

1.Read through these create table rules which you will use as your guide when fixing broken queries:

2. Either the specified column list or inferred columns from a query_statement (or both) must be present.
When both the column list and the as query_statement clause are present, BigQuery ignores the names in the as query_statement clause and matches the columns with the column list by position.

3. When the as query_statement clause is present and the column list is absent, BigQuery determines the column names and types from the as query_statement clause.

4. Column names must be specified either through the column list or as query_statement clause.

5.  Duplicate column names are not allowed.

*/


#standardSQL
--DIAGNÓSTICO DE ERRORES
--Rule #5 duplicate column names are not allowed
--SE REPITE fullVisitorID ya que está dos veces

# copy one day of ecommerce data to explore
CREATE OR REPLACE TABLE ecommerce.all_sessions_raw_20170801
 OPTIONS(
   description="Raw data from analyst team into our dataset for 08/01/2017"
 ) AS
 SELECT fullVisitorID  * FROM `data-to-insights.ecommerce.all_sessions_raw`
 WHERE date = '20170801'  #56,989 records
;

--SOLUCIÓN
# copy one day of ecommerce data to explore
CREATE OR REPLACE TABLE ecommerce.all_sessions_raw_20170801
 OPTIONS(
   description="Raw data from analyst team into our dataset for 08/01/2017"
 ) AS
 SELECT  * FROM `data-to-insights.ecommerce.all_sessions_raw`
 WHERE date = '20170801'  #56,989 records
;


--LO QUE SE SOLICITA EN SCHEMA NO HACE MATCH CON EL SELECT, SE DEBE AJUSTAR LA CANTIDAD DE COLUMNAS SOLICITADAS
--Either the specified column list or inferred columns from a query_statement (or both) must be present.
--When both the column list and the as query_statement clause are present, BigQuery ignores the names in the as query_statement clause and matches the columns with the column list by position.
#standardSQL

# copy one day of ecommerce data to explore
CREATE OR REPLACE TABLE ecommerce.all_sessions_raw_20170801
#schema
(
  fullVisitorId STRING OPTIONS(description="Unique visitor ID"),
  channelGrouping STRING OPTIONS(description="Channel e.g. Direct, Organic, Referral...")
)
 OPTIONS(
   description="Raw data from analyst team into our dataset for 08/01/2017"
 ) AS
 SELECT * FROM `data-to-insights.ecommerce.all_sessions_raw`
 WHERE date = '20170801'  #56,989 records
;

--SOLUCIÓN:PEDIR SOLO DOS COLUMNAS EN EL SELECT

#standardSQL

# copy one day of ecommerce data to explore
CREATE OR REPLACE TABLE ecommerce.all_sessions_raw_20170801
#schema
(
  fullVisitorId STRING OPTIONS(description="Unique visitor ID"),
  channelGrouping STRING OPTIONS(description="Channel e.g. Direct, Organic, Referral...")
)
 OPTIONS(
   description="Raw data from analyst team into our dataset for 08/01/2017"
 ) AS
 SELECT fullVisitorID, channelGrouping FROM `data-to-insights.ecommerce.all_sessions_raw`
 WHERE date = '20170801'  #56,989 records

--SE HACE MAL MACHEO PORQUE CHANNELGROUPING SE MACHEA CON CITY Y NO CON LA COLUMNA CORRECTA
--
/*Although the number of columns match between the schema definition and the query statement, 
the actual column retrieved from the query statement for the channelGrouping column is not 
channelGrouping but rather the visitors city.*/

 #standardSQL

# copy one day of ecommerce data to explore
CREATE OR REPLACE TABLE ecommerce.all_sessions_raw_20170801
#schema
(
  fullVisitorId STRING OPTIONS(description="Unique visitor ID"),
  channelGrouping STRING OPTIONS(description="Channel e.g. Direct, Organic, Referral...")
)
 OPTIONS(
   description="Raw data from analyst team into our dataset for 08/01/2017"
 ) AS
 SELECT fullVisitorId, city FROM `data-to-insights.ecommerce.all_sessions_raw`
 WHERE date = '20170801'  #56,989 records
;


--SOLUCIÓN, PONER channelGrouping en el SELECT en vez de city

--La columna totalTransactionRevenue tiene nulos, así que hay que quitarle la restricción
--The query will fail. You need to specify totalTransactionRevenue as nullable (NULL) since not all visitors will buy
#standardSQL

# copy one day of ecommerce data to explore
CREATE OR REPLACE TABLE ecommerce.all_sessions_raw_20170801
#schema
(
  fullVisitorId STRING NOT NULL OPTIONS(description="Unique visitor ID"),
  channelGrouping STRING NOT NULL OPTIONS(description="Channel e.g. Direct, Organic, Referral..."),
  totalTransactionRevenue INT64 NOT NULL OPTIONS(description="Revenue * 10^6 for the transaction")
)
 OPTIONS(
   description="Raw data from analyst team into our dataset for 08/01/2017"
 ) AS
 SELECT fullVisitorId, channelGrouping, totalTransactionRevenue FROM `data-to-insights.ecommerce.all_sessions_raw`
 WHERE date = '20170801'  #56,989 records
;

--SOLUCIÓN

#standardSQL

# copy one day of ecommerce data to explore
CREATE OR REPLACE TABLE ecommerce.all_sessions_raw_20170801
#schema
(
  fullVisitorId STRING NOT NULL OPTIONS(description="Unique visitor ID"),
  channelGrouping STRING NOT NULL OPTIONS(description="Channel e.g. Direct, Organic, Referral..."),
  totalTransactionRevenue INT64  OPTIONS(description="Revenue * 10^6 for the transaction")
)
 OPTIONS(
   description="Raw data from analyst team into our dataset for 08/01/2017"
 ) AS
 SELECT fullVisitorId, channelGrouping, totalTransactionRevenue FROM `data-to-insights.ecommerce.all_sessions_raw`
 WHERE date = '20170801'  #56,989 records
;

--

#standardSQL

# copy one day of ecommerce data to explore
CREATE OR REPLACE TABLE ecommerce.all_sessions_raw_20170801
#schema
(
  fullVisitorId STRING NOT NULL OPTIONS(description="Unique visitor ID"),
  channelGrouping STRING NOT NULL OPTIONS(description="Channel e.g. Direct, Organic, Referral..."),
  totalTransactionRevenue INT64 OPTIONS(description="Revenue * 10^6 for the transaction")
)
 OPTIONS(
   description="Raw data from analyst team into our dataset for 08/01/2017"
 ) AS
 SELECT fullVisitorId, channelGrouping, totalTransactionRevenue FROM `data-to-insights.ecommerce.all_sessions_raw`
 WHERE date = '20170801'  #56,989 records
;

--Why is the full table name not showing?

--Answer: The table suffix 20170801 is automatically partitioned by day. 
--If we created more tables for other days, the all_sessions_raw_(N) would increment by N distinct days of data.
 --There is another lab that explores different ways of partitioning your data tables.


 /*
Query 6: Your turn to practice
Goal: In the query Editor, create a new permanent table that stores all the transactions with revenue for August 1st, 2017.

Use the below rules as a guide:

Create a new table in your ecommerce dataset titled revenue_transactions_20170801. Replace the table if it already exists.

Source your raw data from the data-to-insights.ecommerce.all_sessions_raw table.

Divide the revenue field by 1,000,000 and store it as a FLOAT64 instead of an INTEGER.

Only include transactions with revenue in your final table (hint: use a WHERE clause).

Only include transactions on 20170801.

Include these fields:

fullVisitorId as a REQUIRED string field.

visitId as a REQUIRED string field (hint: you will need to type convert).

channelGrouping as a REQUIRED string field.

totalTransactionRevenue as a FLOAT64 field.

Add short descriptions for the above four fields by referring to the schema.

Be sure to deduplicate records that have the same fullVisitorId and visitId (hint: use DISTINCT).
*/

--MI SOLUCIÓN

CREATE OR REPLACE TABLE ecommerce.revenue_transactions_20170801
#schema
(
    fullVisitorId STRING NOT NULL OPTIONS(description = "Visitor Id"),
    visitId STRING NOT NULL OPTIONS(description = "Id en string"),
    channelGrouping STRING NOT NULL,
    totalTransactionRevenue FLOAT64 OPTIONS(description = "Revenue dividido 1000000")
)

OPTIONS(


) AS

SELECT DISTINCT fullVisitorId, CAST(visitID AS STRING), channelGrouping,totalTransactionRevenue/1000000
FROM `data-to-insights.ecommerce.all_sessions_raw`
WHERE totalTransactionRevenue is not NULL 
AND date = '20170801';

--SOLUCIÓN DEL LAB

#standardSQL

# copy one day of ecommerce data to explore
CREATE OR REPLACE TABLE ecommerce.revenue_transactions_20170801
#schema
(
  fullVisitorId STRING NOT NULL OPTIONS(description="Unique visitor ID"),
  visitId STRING NOT NULL OPTIONS(description="ID of the session, not unique across all users"),
  channelGrouping STRING NOT NULL OPTIONS(description="Channel e.g. Direct, Organic, Referral..."),
  totalTransactionRevenue FLOAT64 NOT NULL OPTIONS(description="Revenue for the transaction")
)
 OPTIONS(
   description="Revenue transactions for 08/01/2017"
 ) AS
 SELECT DISTINCT
  fullVisitorId,
  CAST(visitId AS STRING) AS visitId,
  channelGrouping,
  totalTransactionRevenue / 1000000 AS totalTransactionRevenue
 FROM `data-to-insights.ecommerce.all_sessions_raw`
 WHERE date = '20170801'
      AND totalTransactionRevenue IS NOT NULL #XX transactions
;


--What are ways to overcome stale data?
/*There are two ways to overcome stale data in reporting tables:

Periodically refresh the permanent tables by re-running queries that insert in new records. This can be done with BigQuery scheduled queries or with a Cloud Dataprep / Cloud Dataflow workflow.
Use logical views to re-run a stored query each time the view is selected
In the remainder of this lab you will focus on how to create logical views.*/


--SAVE QUERIES AS VIEW

#standardSQL
CREATE OR REPLACE VIEW ecommerce.vw_latest_transactions
AS
SELECT DISTINCT
  date,
  fullVisitorId,
  CAST(visitId AS STRING) AS visitId,
  channelGrouping,
  totalTransactionRevenue / 1000000 AS totalTransactionRevenue
 FROM `data-to-insights.ecommerce.all_sessions_raw`
 WHERE totalTransactionRevenue IS NOT NULL
 ORDER BY date DESC # latest transactions
 LIMIT 100
;


#standardSQL
CREATE OR REPLACE VIEW ecommerce.vw_latest_transactions
OPTIONS(
  description="latest 100 ecommerce transactions",
  labels=[('report_type','operational')]
)
AS
SELECT DISTINCT
  date,
  fullVisitorId,
  CAST(visitId AS STRING) AS visitId,
  channelGrouping,
  totalTransactionRevenue / 1000000 AS totalTransactionRevenue
 FROM `data-to-insights.ecommerce.all_sessions_raw`
 WHERE totalTransactionRevenue IS NOT NULL
 ORDER BY date DESC # latest transactions
 LIMIT 100
;

--ERROR PORQUE SOLO TIENE "CREATE"
#standardSQL
# top 50 latest transactions
CREATE VIEW ecommerce.vw_latest_transactions # CREATE
OPTIONS(
  description="latest 50 ecommerce transactions",
  labels=[('report_type','operational')]
)
AS
SELECT DISTINCT
  date,
  fullVisitorId,
  CAST(visitId AS STRING) AS visitId,
  channelGrouping,
  totalTransactionRevenue / 1000000 AS totalTransactionRevenue
 FROM `data-to-insights.ecommerce.all_sessions_raw`
 WHERE totalTransactionRevenue IS NOT NULL
 ORDER BY date DESC # latest transactions
 LIMIT 50
;


/*
View Creation: Your turn to practice
Scenario: Your anti-fraud team has asked you to create a report that lists the 10 most recent transactions that have an order amount of 1,000 or more for them to review manually.

Task: Create a new view that returns all the most recent 10 transactions with revenue greater than 1,000 on or after January 1st, 2017.

Use these rules as a guide:

Create a new view in your ecommerce dataset titled "vw_large_transactions". Replace the view if it already exists.

Give the view a description "large transactions for review".

Give the view a label [("org_unit", "loss_prevention")].

Source your raw data from the data-to-insights.ecommerce.all_sessions_raw table.

Divide the revenue field by 1,000,000.

Only include transactions with revenue greater than or equal to 1,000

Only include transactions on or after 20170101 ordered by most recent first.

Only include currencyCode = 'USD'.

Return these fields:

date
fullVisitorId
visitId
channelGrouping
totalTransactionRevenue AS revenue
currencyCode
v2ProductName



*/

--MI SOLUCIÓN


CREATE OR REPLACE VIEW ecommerce.vw_large_transactions
OPTIONS(
    description = "large transactions for review",
    labels= [("org_unit", "loss_prevention")]
)
AS
SELECT DISTINCT 
date, 
fullVisitorID,
visitId,
channelGrouping,
totalTransactionRevenue/1000000 AS revenue,
currencyCode,
v2ProductName
FROM `data-to-insights.ecommerce.all_sessions_raw`
WHERE (totalTransactionRevenue/1000000)>=1000
AND date>=' 20170101'
AND  currencyCode = 'USD'
ORDER BY date DESC 
LIMIT 10;


--SE LE AGREGA AGG PARA AGRUPAR PRODUCTOS POR FECHA


CREATE OR REPLACE VIEW ecommerce.vw_large_transactions
OPTIONS(
    description = "large transactions for review",
    labels= [("org_unit", "loss_prevention")]
)
AS
SELECT DISTINCT 
date, 
fullVisitorID,
visitId,
channelGrouping,
totalTransactionRevenue/1000000 AS revenue,
currencyCode,
STRING_AGG(DISTINCT v2ProductName ORDER BY v2ProductName LIMIT 10) AS products_ordered
FROM `data-to-insights.ecommerce.all_sessions_raw`
WHERE (totalTransactionRevenue/1000000)>=1000
AND date>=' 20170101'
AND  currencyCode = 'USD'
GROUP BY 1,2,3,4,5,6
ORDER BY date DESC 
LIMIT 10;


SELECT * FROM `ecommerce.vw_large_transactions`

--USO DE SESSION

#standardSQL
SELECT DISTINCT
  SESSION_USER() AS viewer_ldap,
  REGEXP_EXTRACT(SESSION_USER(), r'@(.+)') AS domain,
  date,
  fullVisitorId,
  visitId,
  channelGrouping,
  totalTransactionRevenue / 1000000 AS totalTransactionRevenue,
  currencyCode,
  STRING_AGG(DISTINCT v2ProductName ORDER BY v2ProductName LIMIT 10) AS products_ordered
 FROM `data-to-insights.ecommerce.all_sessions_raw`
 WHERE
  (totalTransactionRevenue / 1000000) > 1000
  AND currencyCode = 'USD'
  AND REGEXP_EXTRACT(SESSION_USER(), r'@(.+)') IN ('qwiklabs.net')

 GROUP BY 1,2,3,4,5,6,7,8
  ORDER BY date DESC # latest transactions

  LIMIT 10



  #standardSQL
CREATE OR REPLACE VIEW ecommerce.vw_large_transactions
OPTIONS(
  description="large transactions for review",
  labels=[('org_unit','loss_prevention')],
  expiration_timestamp=TIMESTAMP_ADD(CURRENT_TIMESTAMP(), INTERVAL 90 DAY)
)
AS
#standardSQL
SELECT DISTINCT
  SESSION_USER() AS viewer_ldap,
  REGEXP_EXTRACT(SESSION_USER(), r'@(.+)') AS domain,
  date,
  fullVisitorId,
  visitId,
  channelGrouping,
  totalTransactionRevenue / 1000000 AS totalTransactionRevenue,
  currencyCode,
  STRING_AGG(DISTINCT v2ProductName ORDER BY v2ProductName LIMIT 10) AS products_ordered
 FROM `data-to-insights.ecommerce.all_sessions_raw`
 WHERE
  (totalTransactionRevenue / 1000000) > 1000
  AND currencyCode = 'USD'
  AND REGEXP_EXTRACT(SESSION_USER(), r'@(.+)') IN ('qwiklabs.net')

 GROUP BY 1,2,3,4,5,6,7,8
  ORDER BY date DESC # latest transactions

  LIMIT 10;