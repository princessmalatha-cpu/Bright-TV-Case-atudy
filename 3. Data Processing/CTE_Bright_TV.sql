-- Databricks notebook source
-- Big query

WITH user_profiles AS(

SELECT Userid,
Province,

CASE 
     WHEN Province ='None' THEN 'Uncategorized'
     WHEN Province=' ' THEN 'Uncategorized'
     WHEN Province IS NULL THEN 'Uncategorized'
     ELSE Province
     END AS Region,

Age,
  CASE 
     WHEN Age=0 THEN 'Infant'
     WHEN Age BETWEEN 1 AND 12 THEN 'Kids'
     WHEN Age BETWEEN 13 AND 19 THEN 'Teenager'
     WHEN Age BETWEEN 20 AND 35 THEN 'Young'
     WHEN Age BETWEEN 36 AND 50 THEN 'Adult'
     WHEN Age >50 AND Age <=60 THEN 'Elderly'
     WHEN Age >60 THEN 'Pensioner'
  END AS Age_Group,

Email,
  CASE
     WHEN (Email IS NOT NULL) OR (EMAIL <> '') OR (EMAIL NOT IN ('None', 'other')) THEN 1
     ELSE 0
     END AS Email_flag,

`Social Media Handle`,
CASE
     WHEN (`Social Media Handle` IS NOT NULL) OR
     (`Social Media Handle` <> '') OR 
     (`Social Media Handle` NOT IN ('None', 'other')) THEN 1 
     ELSE 0 
     END AS socialmedia_flag,

--Checking if each subsriber has a gender. If not replace with Unknown
CASE
     WHEN Gender='None' THEN 'Unknown'
     WHEN Gender=' 'THEN 'Unknown'
     WHEN Gender IS NULL THEN 'Unknown'
     ELSE Gender
     END AS Gender,

--Checking the race column replacing Other and None with Unknown
CASE 
   WHEN race='other' THEN 'Unknown' 
   WHEN race= 'None' THEN 'Unknown'
   WHEN race=' 'THEN 'Unknown'
   ELSE race 
   END AS Ethnicity
FROM tvdataset.brighttv.user_profiles),


Base_viewership AS
              (SELECT
              COALESCE (UserID0, userid4) AS User_id,-- combining two user ids into one
              From_UTC_Timestamp(RecordDate2, 'Africa/Johannesburg') AS RecordDate_SAST,--converting timestamp to SA time 
	          Channel2,
             `Duration 2`
FROM tvdataset.brighttv.viewership
),
Viewership AS
( SELECT
              User_id,
              RecordDate_SAST,
              TO_DATE(RecordDate_SAST) AS watch_date, -- Convert a string into a date YYYY-MM=-DD 
              DAYNAME(TO_DATE(RecordDate_SAST))AS day_name, -- Extract the day name 
              MONTHNAME(TO_DATE(RecordDate_SAST)) AS month_name, -- Extracts the month name 
               YEAR(TO_DATE(RecordDate_SAST)) AS event_year, -- Extracts the year value 
               DAY(TO_DATE(RecordDate_SAST)) AS event_day, -- Extracts the day value 
               HOUR(RecordDate_SAST) AS Hour_of_day,--extracts hour of day
        CASE 
               WHEN DAYNAME(TO_DATE(RecordDate_SAST)) IN ('Sat', 'Sun') THEN '02. Weekend' 
               ELSE '01. Weekday' 
        END AS day_classification,

        date_format(RecordDate_SAST, 'HH:mm:ss') AS Watch_time,--converting date format to time
    CASE
        WHEN watch_time BETWEEN '00:00:00' AND '05:59:59' THEN '01. Midnight'
        WHEN watch_time BETWEEN '06:00:00' AND '11:59:59' THEN '02. Morning'
        WHEN watch_time BETWEEN '12:00:00' AND '16:59:59' THEN '03. Afternoon'
        WHEN watch_time BETWEEN '17:00:00' AND '23:59:59' THEN '04. Evening'
    END AS Time_of_day,

    
     `Duration 2`,
        DATE_FORMAT(`Duration 2`, 'HH:mm:ss') AS Duration,--converting duration into time format
(
    HOUR(TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss')) +
    MINUTE(TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss')) / 60.0 + --converting minutes to seconds
    SECOND(TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss')) / 3600.0--converting seconds to minutes
) AS Duration_hours, 

        (
            HOUR(TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss')) * 3600 + --converting hours to seconds
            MINUTE(TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss')) * 60 + ---converting minutes to seconds
            SECOND(TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss'))
        ) AS Duration_seconds,    

    CASE
        WHEN Duration_seconds BETWEEN 300 AND 1800 THEN '01. Low Usage (<30 min)'
        WHEN Duration_seconds BETWEEN 1801 AND 3599 THEN '02. Medium Usage (<60 min)'
        WHEN Duration_seconds >= 3600 THEN '03. High Usage (>60 min)'
        ELSE '04. No Usage'
    END AS Screen_time_bucket, 

      CASE --cleaning channel
        WHEN Channel2 IN ('SawSee','Sawsee') THEN 'SawSee'
        WHEN Channel2 IN ('SuperSport Live Events','Live on SuperSport', 'Supersport Live Events', 'DStv Events 1') THEN 'Live Events'
        ELSE Channel2
    END AS Tv_channel
FROM Base_viewership)

----Creating the final table
SELECT 
      COALESCE (A. User_id, B. UserID) AS Sub_ID,
          B.Ethnicity,
          B.Gender,
          B.Age_group,
          B.Region,
          B.Email_flag,
          B.socialmedia_flag,
          RecordDate_SAST,
          Watch_date,
          Day_name,
          Month_name,
          Event_year,
          Event_day,
          Hour_of_day,
          Day_classification,
          Watch_time,
          Time_of_day,
          Duration,
          Duration_hours,
          Duration_seconds,
          Screen_time_bucket, 
          Tv_channel
FROM Viewership AS A
LEFT JOIN user_profiles AS B
ON A.User_id=B.UserID;




