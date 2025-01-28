-- 31.	Which stadium has the highest capacity?
SELECT NAME AS STADIUM_NAME, CITY, COUNTRY, CAPACITY
FROM Stadiums
ORDER BY CAPACITY DESC
LIMIT 1;

-- 32.	How many stadiums are located in a ‘Russia’ country or ‘London’ city?
SELECT COUNT(*) AS Stadium_Count
FROM Stadiums
WHERE COUNTRY = 'Russia' OR CITY = 'London';

-- 33.	Which stadium hosted the most matches during a season?
SELECT STADIUM, SEASON, COUNT(*) AS Match_Count
FROM Matches
GROUP BY STADIUM, SEASON
ORDER BY Match_Count DESC
LIMIT 1;

-- 34. What is the average stadium capacity for teams participating in a each season?
SELECT M.SEASON, AVG(CAST(S.CAPACITY AS NUMERIC)) AS Avg_Stadium_Capacity
FROM Matches M
JOIN Stadiums S ON M.STADIUM = S.NAME
GROUP BY M.SEASON
ORDER BY M.SEASON;

-- 35.	How many teams play in stadiums with a capacity of more than 50,000?
SELECT COUNT(DISTINCT TEAM) AS Team_Count
FROM (
    SELECT M.HOME_TEAM AS TEAM, CAST(S.CAPACITY AS INTEGER) AS CAPACITY
    FROM Matches M
    JOIN Stadiums S ON M.STADIUM = S.NAME
    WHERE CAST(S.CAPACITY AS INTEGER) > 50000
    UNION
    SELECT M.AWAY_TEAM AS TEAM, CAST(S.CAPACITY AS INTEGER) AS CAPACITY
    FROM Matches M
    JOIN Stadiums S ON M.STADIUM = S.NAME
    WHERE CAST(S.CAPACITY AS INTEGER) > 50000
) AS TeamsInLargeStadiums;

-- 36.	Which stadium had the highest attendance on average during a season?
SELECT STADIUM, SEASON, AVG(ATTENDANCE) AS Avg_Attendance
FROM Matches
GROUP BY STADIUM, SEASON
ORDER BY Avg_Attendance DESC
LIMIT 1;

-- 37.	What is the distribution of stadium capacities by country?
SELECT 
    COUNTRY,
    MIN(CAST(CAPACITY AS INTEGER)) AS Min_Capacity,
    MAX(CAST(CAPACITY AS INTEGER)) AS Max_Capacity,
    AVG(CAST(CAPACITY AS NUMERIC)) AS Avg_Capacity,
    SUM(CAST(CAPACITY AS INTEGER)) AS Total_Capacity,
    COUNT(*) AS Stadium_Count
FROM Stadiums
GROUP BY COUNTRY
ORDER BY COUNTRY;


