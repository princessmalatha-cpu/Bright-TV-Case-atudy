-- Databricks notebook source
-------------------------------------
--Checking all columns in the table
--------------------------------------
select * 
from `tvdataset`.`brighttv`.`viewership` 
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
SELECT COUNT(*)
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

Viwership AS(

SELECT COALESCE(UserID0, userid4) AS UserID,
       TO_CHAR(RecordDate2) AS Month_id,
       TO_DATE(RecordDate2 AS watch_date,
       TIME(RecordDte2) AS watch_time,
       TO_CHAR(RecordDate2) AS'DD') AS day_of _the_week,
       DAYNAME(TO_DATE(RecordDate2)) AS DAY_Name,)
CASE
       WHEN DAYNAME(TO_DATE(RecordDate2)) IN ('Sat', 'Sun') THEN 'Weekend'
       ELSE 'Weekday'
       END AS Day_Classification,
       MONTHNAME(TO_DATE(RecordDate2)) AS MONTH_NAME,
CASE 
       WHEN Channel2 IN ('Sawsee''Sawsee') THEN 'Sawsee'
       WHEN Channel2 IN('Supersport Live Events', Live on SuperSport', 'Supersport Live Events','Dstv Events 1') THEN 'Live Events'
       ELSE Channel2
       END AS
       Tv_Channel,date_format(RecordDate2,HH:mm:ss) AS watch_time,

 CASE 
     WHEN watch_time BETWEEN '00:00:00' AND '05:59:59'  THEN '01.Midnight'
     WHEN watch_time BETWEEN '06:00:00' AND '11:59:59' THEN '02.Morning'
     WHEN watch_time BETWEEN '12:00:00' AND '16:59:59' THEN '03.Afternoon'
     WHEN watch_time BETWEEN '17:00:00' AND '23:59:59' THEN '04.Evening'
     END AS Time_of_day,
     DATE_FORMAT(Duration 2, 'HH:mm:ss') AS duration,
CASE
     WHEN Duration 2 BETWEEN '00:05:00' AND '00:30:00' THEN '01.Low Usage:<30 min'
     WHEN Duration 2 BETWEEN '00:30:01' AND '00:59:59' THEN '02. Med Usage:<60 min' 
     WHEN Duration 2 >'00:59:59' THEN '03.High Usage:>60 min'
     ELSE '04. No Usage'
     END AS Screen_time_budget,
     HOUR(RecordDate2) AS hour_of_the_day
     
     

       
       YEAR(TO_DATE(RecordDate2)) AS Event_Year,
       DAY(TO_DATE(RecordDate2)) AS event_dt
)