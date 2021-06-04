#standardSQL
SELECT person, fruit_array, total_cost FROM `data-to-insights.advanced.fruit_store`;


SELECT STRUCT  ("Rudisha"as name, 23.4 as split) as runner;

#standardSQL
SELECT STRUCT("Rudisha" as name, [23.4, 26.3, 26.4, 26.1] as splits) AS runner;

#standardSQL
SELECT * FROM racing.race_results

#standardSQL
SELECT race, participants.name
FROM racing.race_results

#standardSQL
SELECT race, participants.name
FROM racing.race_results
CROSS JOIN
participants  
#--this is the STRUCT (it's like a table within a table)



#standardSQL
SELECT race, participants.name
FROM racing.race_results
CROSS JOIN
race_results.participants # full STRUCT name



#standardSQL
SELECT race, participants.name
FROM racing.race_results AS r, r.participants


#Task: Write a query to COUNT how many racers were there in total.
#standardSQL

WITH cuenta AS (
    SELECT race, participants.name as participantes
    FROM racing.race_results
    CROSS JOIN
    race_results.participants # full STRUCT name
)
SELECT COUNT(distinct participantes ) as nro_races
FROM cuenta
#Solución del lab
#standardSQL
SELECT COUNT(p.name) AS racer_count
FROM racing.race_results AS r, UNNEST(r.participants) AS p



#standardSQL
SELECT
['Rudisha','Makhloufi','Murphy','Bosse','Rotich','Lewandowski','Kipketer','Berian'] AS normal_array


#standardSQL
SELECT * FROM
UNNEST(['Rudisha','Makhloufi','Murphy','Bosse','Rotich','Lewandowski','Kipketer','Berian']) AS unnested_array_of_names


#standardSQL
SELECT * FROM
UNNEST(['Rudisha','Makhloufi','Murphy','Bosse','Rotich','Lewandowski','Kipketer','Berian']) AS unnested_array_of_names
WHERE unnested_array_of_names LIKE 'M%'

/*
Write a query that will list the total race time for racers whose names begin with R. Order the results with the fastest total time first.
 Use the and start with the partially written query below
*/


#standardSQL
SELECT
  p.name,
  SUM(split_times) as total_race_time
FROM racing.race_results AS r
, r.participants AS p
, p.splits AS split_times
WHERE p.name LIKE 'R%'
GROUP BY p.name
ORDER BY total_race_time DESC


/*
You happened to see that the fastest lap time recorded for the 800 M race was 23.2 seconds, 
but you did not see which runner ran that particular lap. Create a query that returns that result.
*/




#
standardSQL

SELECT
  p.name,
  split_time
FROM racing.race_results AS r
, UNNEST(r.participants) AS p
, UNNEST(p.splits) AS split_time
WHERE split_time =23.2 ;

#Top two Hacker News articles by day

WITH TitleAndScores AS (
    SELECT 
    ARRAY_AGG(STRUCT(title, score)) AS titles,
    EXTRACT(DATE FROM time_ts) AS date 
    FROM `bigquery-public-data.hacker_news.stories`
    WHERE score IS NOT NULL AND title IS NOT NULL 
    GROUP BY date

)

SELECT date, 
    ARRAY(SELECT AS STRUCT title, score
    FROM UNnEST(titles) ORDER BY score DESC LIMIT 2)
    AS top_articles 
    FROM TitleAndScores



WITH fruits AS(
    SELECT 800 as race, [ STRUCT("Sally" as name, ['raspberry', 'blackberry', 'strawberry', 'cherry'] as fruit),
        STRUCT ("Frederick" as name, ['xorange', 'apple'] as fruit) ]
        AS fruit_store
)


#Mostrar 800 para Sally y Frederick

SELECT race, fruit_store.name
FROM fruits
CROSS JOIN  fruits.fruit_store

