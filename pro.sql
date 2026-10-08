CREATE DATABASE MentalHealthDB;
USE MentalHealthDB;
CREATE TABLE Mental_Health_Care (
    Indicator VARCHAR(100),
    `Group` VARCHAR(50), -- Group is a reserved keyword in SQL
    State VARCHAR(50),
    Subgroup VARCHAR(100),
    Phase INT,
    `Time Period` VARCHAR(50),
    `Time Period Label` VARCHAR(100),
    `Time Period Start Date` DATE,
    `Time Period End Date` DATE,
    `Value` FLOAT,
    LowCI FLOAT,
    HighCI FLOAT,
    `Confidence Interval` VARCHAR(50),
    `Quartile Range` VARCHAR(50),
    `Suppression Flag` VARCHAR(10)
);

LOAD DATA INFILE 'Mental_Health_Care_in_the_Last_4_Weeks.csv'
INTO TABLE Mental_Health_Care
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    Indicator,
    `Group`,
    State,
    Subgroup,
    Phase,
    `Time Period`,
    `Time Period Label`,
    `Time Period Start Date`,
    `Time Period End Date`,
    `Value`,
    LowCI,
    HighCI,
    `Confidence Interval`,
    `Quartile Range`,
    `Suppression Flag`
);

SELECT AVG(Value) AS Avg_Value, MIN(Value) AS Min_Value, MAX(Value) AS Max_Value
FROM mental_health_care_in_the_last_4_weeks;

SELECT COUNT(*) AS Null_Count
FROM mental_health_care_in_the_last_4_weeks
WHERE Value IS NULL;

SELECT COUNT(*) AS Total_Count
FROM mental_health_care_in_the_last_4_weeks;

SELECT `Group`, AVG(Value) AS Avg_Value
FROM mental_health_care_in_the_last_4_weeks
GROUP BY `Group`;

SELECT `Time Period Start Date`, AVG(Value) AS Avg_Value
FROM mental_health_care_in_the_last_4_weeks
GROUP BY `Time Period Start Date`
ORDER BY `Time Period Start Date`;




