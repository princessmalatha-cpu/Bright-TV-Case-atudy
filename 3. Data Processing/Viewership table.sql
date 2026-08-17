-- Databricks notebook source

-------------------------------------
--Checking all columns in the table
--------------------------------------
select * 
from `tvdataset`.`brighttv`.`viewership`;
-------------------------------------------------------------------
--Checking if there is any row where in the column UserID0 is empty
--------------------------------------------------------------------
SELECT*
FROM tvdataset.brighttv.viewership
WHERE UserID0 IS NULL
OR userid4 IS NULL;
--------------------------------------------------------------------
SELECT*
FROM tvdataset.brighttv.viewership
WHERE UserID0<> userid4;
--------------------------------------------------------------------
--Checking for duplicates
--------------------------------------------------------------------
SELECT COUNT(*),
        UserID0,RecordDate2
FROM tvdataset.brighttv.viewership
GROUP BY UserID0,RecordDate2
HAVING COUNT(*)>1;
--------------------------------------------------------------------

SELECT UserID0,
       TO_DATE(RecordDate2) AS Watch_DATE,--converts a string into a date YYYY-MM-DD
       DAYNAME(TO_DATE(RecordDate2)) AS DAY_Name,--Extracts the day name 
       CASE
         WHEN DAYNAME(TO_DATE(RecordDate2)) IN ('Sat', 'Sun') THEN '02. Weekend'
         ELSE '01. Weekday'
         END AS Day_Classification,
         
        MONTHNAME(TO_DATE(RecordDate2)) AS MONTH_NAME,----Extract the month name
       YEAR(TO_DATE(RecordDate2)) AS Event_Year,
       DAY(TO_DATE(RecordDate2)) AS event_dt----Extracts the day value   
FROM tvdataset.brighttv.viewership
WHERE UserID0 IS NOT NULL
GROUP BY ALL
ORDER BY watch_date DESC;

CREATE OR REPLACE TEMPORARY TABLE Viwership AS(

SELECT COALESCE(UserID0, userid4) AS UserID,
       DATE_FORMAT(RecordDate2, 'yyyy-MM') AS Month_id,
       TO_DATE(RecordDate2) AS watch_date,
       DATE_FORMAT(RecordDate2, 'HH:mm:ss') AS watch_time,
       DATE_FORMAT(RecordDate2, 'dd') AS day_of_the_week,
       DAYNAME(TO_DATE(RecordDate2)) AS DAY_Name,
       CASE
         WHEN DAYNAME(TO_DATE(RecordDate2)) IN ('Sat', 'Sun') THEN 'Weekend'
         ELSE 'Weekday'
       END AS Day_Classification,
       MONTHNAME(TO_DATE(RecordDate2)) AS MONTH_NAME,
       CASE 
         WHEN Channel2 IN ('Sawsee', 'Sawsee') THEN 'Sawsee'
         WHEN Channel2 IN ('Supersport Live Events', 'Live on SuperSport', 'Supersport Live Events', 'Dstv Events 1') THEN 'Live Events'
         ELSE Channel2
       END AS Tv_Channel,
       CASE 
         WHEN DATE_FORMAT(RecordDate2, 'HH:mm:ss') BETWEEN '00:00:00' AND '05:59:59' THEN '01.Midnight'
         WHEN DATE_FORMAT(RecordDate2, 'HH:mm:ss') BETWEEN '06:00:00' AND '11:59:59' THEN '02.Morning'
         WHEN DATE_FORMAT(RecordDate2, 'HH:mm:ss') BETWEEN '12:00:00' AND '16:59:59' THEN '03.Afternoon'
         WHEN DATE_FORMAT(RecordDate2, 'HH:mm:ss') BETWEEN '17:00:00' AND '23:59:59' THEN '04.Evening'
       END AS Time_of_day,
       DATE_FORMAT(`Duration 2`, 'HH:mm:ss') AS duration,
       CASE
         WHEN `Duration 2` BETWEEN '00:05:00' AND '00:30:00' THEN '01.Low Usage:<30 min'
         WHEN `Duration 2` BETWEEN '00:30:01' AND '00:59:59' THEN '02. Med Usage:<60 min' 
         WHEN `Duration 2` > '00:59:59' THEN '03.High Usage:>60 min'
         ELSE '04. No Usage'
       END AS Screen_time_budget,
       HOUR(RecordDate2) AS hour_of_the_day,
       YEAR(TO_DATE(RecordDate2)) AS Event_Year,
       DAY(TO_DATE(RecordDate2)) AS event_dt
FROM tvdataset.brighttv.viewership






-- The first code SELECT* is to help see what is in the table
SELECT*
FROM tvdataset.brighttv.viewership
LIMIT 10;

-- Applying DATE FUNCTIONS these are used in the date column to extract date i.e. day, month, year
-- In this select statement 'RecordDate2' is a date column a.k.a timestamp and it will return watch_time in the YYY-MM-DD format 

SELECT TO_DATE(RecordDate2) AS watch_date --TO_DATE Converts a string into a date YYYT-MM-DD
FROM tvdataset.brighttv.viewership;

-- Here, we just added the RecordDate2 column to the select statement and the watch_date column to return both columns
SELECT 
    RecordDate2,
    TO_DATE(RecordDate2) AS watch_date --TO_DATE Converts a string into a date YYYT-MM-DD
FROM tvdataset.brighttv.viewership;

-- Now let's extract the dates using more DATE FUNCTIONS names, year, and day
SELECT 
    RecordDate2,
    TO_DATE(RecordDate2) AS watch_date, --TO_DATE Converts a string into a date YYYT-MM-DD
    DAYNAME(TO_DATE(RecordDate2)) AS day_name, -- Extracts the day name
    MONTHNAME(TO_DATE(RecordDate2)) AS month_name, -- Extracts the month name
    YEAR(TO_DATE(RecordDate2)) AS event_year, -- Extracts the year value
    DAY(TO_DATE(RecordDate2)) AS event_dt -- Extracts day value
FROM tvdataset.brighttv.viewership;
-- DATE FUNCTIONS allow us to build a CASE statement within them
-- Also returning Count Distinct number of subscribers
-- And then create a Temporary TABLE to save the results and create your own version of the table, here it will be called 'viewership'
CREATE OR REPLACE TEMPORARY VIEW viewership AS (
SELECT 
    COUNT(DISTINCT UserID0) AS number_of_subs,
    RecordDate2,
    TO_DATE(RecordDate2) AS watch_date, --TO_DATE Converts a string into a date YYYT-MM-DD
    DAYNAME(TO_DATE(RecordDate2)) AS day_name, -- Extracts the day name
    CASE 
        WHEN DAYNAME(TO_DATE(RecordDate2)) IN ('Sat', 'Sun') THEN '02. Weekend'
        ELSE '01. Weekday'
    END AS Day_classification,
    MONTHNAME(TO_DATE(RecordDate2)) AS month_name, -- Extracts the month name
    YEAR(TO_DATE(RecordDate2)) AS event_year, -- Extracts the year value
    DAY(TO_DATE(RecordDate2)) AS event_dt -- Extracts day value
FROM tvdataset.brighttv.viewership
WHERE UserID0 IS NOT NULL
GROUP BY ALL
ORDER BY watch_date DESC);

-- How many people are watching Weekdays and Weekends
SELECT SUM (number_of_subs) AS subs,
        day_classification
FROM viewership
Group BY day_classification;

SELECT *
FROM viewership































);