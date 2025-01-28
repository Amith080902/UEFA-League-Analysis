-- 26.	Which team has the largest home stadium in terms of capacity?
SELECT STADIUM, HOME_TEAM, MAX(ATTENDANCE) AS Largest_Attendance
FROM Matches
GROUP BY STADIUM, HOME_TEAM
ORDER BY Largest_Attendance DESC
LIMIT 1;

-- 27.	Which teams from a each country participated in the UEFA competition in a season?
-- -- Replace '2016-2017' with the desired season
SELECT DISTINCT T.COUNTRY, M.SEASON, M.HOME_TEAM AS TEAM_NAME
FROM Matches M
JOIN Teams T
ON M.HOME_TEAM = T.TEAM_NAME
WHERE M.SEASON = '2016-2017'
ORDER BY T.COUNTRY, M.SEASON, TEAM_NAME;

-- 28.	Which team scored the most goals across home and away matches in a given season?
SELECT TEAM_NAME, SEASON, SUM(TOTAL_GOALS) AS TOTAL_GOALS
FROM (
    SELECT HOME_TEAM AS TEAM_NAME, SEASON, SUM(HOME_TEAM_SCORE) AS TOTAL_GOALS
    FROM Matches
    GROUP BY HOME_TEAM, SEASON
    UNION ALL
    SELECT AWAY_TEAM AS TEAM_NAME, SEASON, SUM(AWAY_TEAM_SCORE) AS TOTAL_GOALS
    FROM Matches
    GROUP BY AWAY_TEAM, SEASON
) AS Combined
GROUP BY TEAM_NAME, SEASON
ORDER BY TOTAL_GOALS DESC
LIMIT 1;

-- 29.	How many teams have home stadiums in a each city or country?
SELECT COUNTRY, COUNT(DISTINCT TEAM_NAME) AS TEAM_COUNT
FROM Teams
GROUP BY COUNTRY
ORDER BY TEAM_COUNT DESC;

-- 30.	Which teams had the most home wins in the 2021-2022 season?
SELECT HOME_TEAM AS TEAM_NAME, COUNT(*) AS HOME_WINS
FROM Matches
WHERE SEASON = '2021-2022' AND HOME_TEAM_SCORE > AWAY_TEAM_SCORE
GROUP BY HOME_TEAM
ORDER BY HOME_WINS DESC;


