-- Databricks notebook source
SELECT*
FROM tvdataset.brighttv.user_profiles;

SELECT*
FROM tvdataset.brighttv.viewership;

-------------------------------
----Gender Checks 
------------------------------

SELECT DISTINCT Gender
FROM tvdataset.brighttv.user_profiles;

SELECT DISTINCT 
CASE WHEN Gender='None' THEN 'Unknown'----Replaces the value Nonw with unknown
WHEN Gender=' 'THEN 'Unknown'--- Replaces the empty space with unknown
WHEN Gender IS NULL THEN 'Unknown'---Replaces null with unknown
ELSE Gender--- if gender is male or female return it as it is
END AS SEX---new column name
FROM tvdataset.brighttv.user_profiles;
 --------------------------------
 Race Checks
 -------------------------------
SELECT DISTINCT Race 
From tvdataset.brighttv.user_profiles;

SELECT COUNT(DISTINCT Userid) AS subs,
CASE 
WHEN race='other' THEN 'Unknown'--- Replaces other with unkown
WHEN race= 'None' THEN 'Unknown'---Replace none with unknown
WHEN race=' 'THEN 'Unknown'--Replace empty space with unknown
WHEN race IS NULL THEN 'Unknown'---Replace null with unknown
ELSE race---keep it as race
END AS Ethnicity--new column name
From tvdataset.brighttv.user_profiles
GROUP BY Ethnicity;
----------------------------------
Province Check
---------------------------------
SELECT DISTINCT Province
From tvdataset.brighttv.user_profiles;

SELECT DISTINCT 
CASE 
     WHEN Province ='None' THEN 'Unknown'
     WHEN Province=' ' THEN 'Unknown'
     WHEN Province IS NULL THEN 'Unknown'
ELSE Province
END AS Region 
From  tvdataset.brighttv.user_profiles;
--------------------------------------
Age Checks
--------------------------------------
SELECT MIN(Age) AS Min_age,
       MAX(Age) AS Max_age,
       AVG(Age) AS mean_age
FROM tvdataset.brighttv.user_profiles;

SELECT
  CASE 
     WHEN Age=0 THEN 'Infant'
     WHEN Age BETWEEN 1 AND 12 THEN 'Kids'
     WHEN Age BETWEEN 13 AND 17 THEN 'Youth'
     WHEN Age BETWEEN 18 AND 35 THEN 'Young Adults'
     WHEN Age BETWEEN 36 AND 50 THEN 'Adults'
     WHEN Age >50 AND Age <=60 THEN 'Elderly'
     WHEN Age >60 THEN 'Pensioner'
  END AS Age_Group
  FROM tvdataset.brighttv.user_profiles;

-------------------------------------------------
CREATE OR REPLACE TEMPORARY VIEW user_profiles_enriched AS
-------------------------------------------------
SELECT Userid,

CASE 
     WHEN Province ='None' THEN 'Uncategorized'
     WHEN Province=' ' THEN 'Uncategorized'
     WHEN Province IS NULL THEN 'Uncategorized'
     ELSE Province
     END AS Region,
-----------------------------------------

-----------------------------------------

Age,
  CASE 
     WHEN Age=0 THEN 'Infant'
     WHEN Age BETWEEN 1 AND 12 THEN 'Kids'
     WHEN Age BETWEEN 13 AND 19 THEN 'Teenager'
     WHEN Age BETWEEN 20 AND 35 THEN 'Young'
     WHEN Age BETWEEN 36 AND 50 THEN 'Adult'
     WHEN Age >51 AND Age <=60 THEN 'Elderly'
     WHEN Age >60 THEN 'Pensioner'
  END AS Age_Group,

  CASE
     WHEN (Email IS NOT NULL) OR (EMAIL <> '') OR (EMAIL NOT IN ('None', 'other')) THEN 1
     ELSE 0
     END AS Email_flag,
CASE
     WHEN (`Social Media Handle` IS NOT NULL) OR (`Social Media Handle` <> '') OR (`Social Media Handle` NOT IN ('None', 'other')) THEN 1 
     ELSE 0 
     END AS socialmedia_flag,
CASE
     WHEN Gender='None' THEN 'Unknown'
     WHEN Gender=' 'THEN 'Unknown'
     WHEN Gender IS NULL THEN 'Unknown'
     ELSE Gender
     END AS Gender,

  
CASE 
   WHEN race='other' THEN 'Unknown' 
   WHEN race= 'None' THEN 'Unknown'
   WHEN race=' 'THEN 'Unknown'
   ELSE race 
   END AS Ethnicity
FROM tvdataset.brighttv.user_profiles;

WITH Viewership AS (
  SELECT 
    COALESCE(UserID0, userid4) AS UserID,
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
    END AS Screen_time_bucket,
    HOUR(RecordDate2) AS hour_of_the_day 
  FROM tvdataset.brighttv.viewership
)
SELECT
  COALESCE(A.UserID, B.Userid) AS SUB_ID,
  A.month_id,
  A.watch_date,
  A.day_name,
  A.day_classification,
  A.month_name,
  A.Tv_channel,
  A.time_of_day,
  A.hour_of_the_day,
  A.screen_time_bucket,
  A.duration,
  B.Region,
  B.Age_Group,
  B.Email_flag,
  B.socialmedia_flag,
  B.Ethnicity,
  B.Gender
FROM Viewership AS A
LEFT JOIN user_profiles_enriched AS B
  ON A.UserID = B.Userid;



