-- Databricks notebook source
----------------------------------------
---This is to check what the data looks like
-----------------------------------------

SELECT*
FROM tvdataset.brighttv.user_profiles
LIMIT 100;

----------------------------------
--Checking for Duplicates
----------------------------------
SELECT COUNT(*)
       userid
FROM tvdataset.brighttv.user_profiles
GROUP BY userid 
HAVING COUNT (*)>1;

-------------------------------
----Gender Checks 
------------------------------

SELECT DISTINCT Gender
FROM tvdataset.brighttv.user_profiles;

SELECT DISTINCT 
CASE WHEN Gender='None' THEN 'Unknown'----Replaces the value None with unknown
WHEN Gender=' 'THEN 'Unknown'--- Replaces the empty space with unknown
WHEN Gender IS NULL THEN 'Unknown'---Replaces null with unknown
ELSE Gender--- if gender is male or female return it as it is
END AS SEX---new column name
FROM tvdataset.brighttv.user_profiles;

 --------------------------------
---Race Checks
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
--Province Check
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
---Age Checks
--------------------------------------
SELECT MIN(Age) AS Min_age,---Youngest person in the dataset
       MAX(Age) AS Max_age,--find the oldest person in the dataset
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
