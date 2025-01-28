-- 38.	Which players scored the most goals in matches held at a specific stadium?
-- Replace 'Giuseppe Meazza' with the desired stadium name
SELECT 
    p.PLAYER_ID,
    p.FIRST_NAME,
    p.LAST_NAME,
    m.STADIUM,
    COUNT(g.GOAL_ID) AS TOTAL_GOALS
FROM 
    goals g
JOIN 
    matches m ON g.MATCH_ID = m.MATCH_ID
JOIN 
    players p ON g.PID = p.PLAYER_ID
WHERE 
    m.STADIUM = 'Giuseppe Meazza' 
GROUP BY 
    p.PLAYER_ID, p.FIRST_NAME, p.LAST_NAME, m.STADIUM
ORDER BY 
    TOTAL_GOALS DESC
LIMIT 1;

-- 39.	Which team won the most home matches in the season 2021-2022 (based on match scores)?
SELECT 
    HOME_TEAM,
    COUNT(*) AS HOME_WINS
FROM 
    matches
WHERE 
    SEASON = '2021-2022' 
    AND HOME_TEAM_SCORE > AWAY_TEAM_SCORE
GROUP BY 
    HOME_TEAM
ORDER BY 
    HOME_WINS DESC
LIMIT 1;

-- 40.	Which players played for a team that scored the most goals in the 2021-2022 season?
-- Step 1: Find the team that scored the most goals
WITH TeamGoals AS (
    SELECT 
        HOME_TEAM AS TEAM,
        SUM(HOME_TEAM_SCORE) AS TOTAL_GOALS
    FROM 
        matches
    WHERE 
        SEASON = '2021-2022'
    GROUP BY 
        HOME_TEAM
    UNION ALL
    SELECT 
        AWAY_TEAM AS TEAM,
        SUM(AWAY_TEAM_SCORE) AS TOTAL_GOALS
    FROM 
        matches
    WHERE 
        SEASON = '2021-2022'
    GROUP BY 
        AWAY_TEAM
)
, MostGoalsTeam AS (
    SELECT 
        TEAM,
        SUM(TOTAL_GOALS) AS TOTAL_GOALS
    FROM 
        TeamGoals
    GROUP BY 
        TEAM
    ORDER BY 
        TOTAL_GOALS DESC
    LIMIT 1
)

-- Step 2: Get players from the team
SELECT 
    p.PLAYER_ID,
    p.FIRST_NAME,
    p.LAST_NAME,
    p.POSITION,
    p.TEAM
FROM 
    players p
JOIN 
    MostGoalsTeam t ON p.TEAM = t.TEAM;

-- 41.	How many goals were scored by home teams in matches where the attendance was above 50,000?
SELECT 
    SUM(HOME_TEAM_SCORE) AS TOTAL_HOME_GOALS
FROM 
    matches
WHERE 
    ATTENDANCE > 50000;

-- 42.	Which players played in matches where the score difference (home team score - away team score) was the highest?
-- Step 1: Find the match with the highest score difference
WITH HighestScoreDifferenceMatch AS (
    SELECT 
        MATCH_ID,
        ABS(HOME_TEAM_SCORE - AWAY_TEAM_SCORE) AS SCORE_DIFFERENCE
    FROM 
        matches
    ORDER BY 
        SCORE_DIFFERENCE DESC
    LIMIT 1
)

-- Step 2: Get players from the match
SELECT 
    p.PLAYER_ID,
    p.FIRST_NAME,
    p.LAST_NAME,
    p.POSITION,
    p.TEAM
FROM 
    players p
JOIN 
    goals g ON p.PLAYER_ID = g.PID
JOIN 
    HighestScoreDifferenceMatch hsm ON g.MATCH_ID = hsm.MATCH_ID;

-- 43.	How many goals did players score in matches that ended in penalty shootouts?
SELECT 
    COUNT(g.GOAL_ID) AS TOTAL_GOALS
FROM 
    goals g
JOIN 
    matches m ON g.MATCH_ID = m.MATCH_ID
WHERE 
    m.PENALTY_SHOOT_OUT = 1;

-- 44.	What is the distribution of home team wins vs away team wins by country for all seasons?
SELECT 
    s.COUNTRY,
    SUM(CASE WHEN HOME_TEAM_SCORE > AWAY_TEAM_SCORE THEN 1 ELSE 0 END) AS HOME_TEAM_WINS,
    SUM(CASE WHEN AWAY_TEAM_SCORE > HOME_TEAM_SCORE THEN 1 ELSE 0 END) AS AWAY_TEAM_WINS
FROM 
    stadiums s JOIN matches m ON s.name=m.stadium
GROUP BY 
    s.COUNTRY
ORDER BY 
    s.COUNTRY;

-- 45.	Which team scored the most goals in the highest-attended matches?
-- Step 1: Identify the highest attendance
WITH HighestAttendance AS (
    SELECT 
        MAX(ATTENDANCE) AS MAX_ATTENDANCE
    FROM 
        matches
),

-- Step 2: Get matches with the highest attendance
HighestAttendedMatches AS (
    SELECT 
        MATCH_ID, 
        HOME_TEAM, 
        HOME_TEAM_SCORE, 
        AWAY_TEAM, 
        AWAY_TEAM_SCORE
    FROM 
        matches
    WHERE 
        ATTENDANCE = (SELECT MAX_ATTENDANCE FROM HighestAttendance)
)

-- Step 3: Sum goals by team
SELECT 
    TEAM,
    SUM(GOALS) AS TOTAL_GOALS
FROM (
    SELECT 
        HOME_TEAM AS TEAM,
        HOME_TEAM_SCORE AS GOALS
    FROM 
        HighestAttendedMatches
    UNION ALL
    SELECT 
        AWAY_TEAM AS TEAM,
        AWAY_TEAM_SCORE AS GOALS
    FROM 
        HighestAttendedMatches
) AS TeamGoals
GROUP BY 
    TEAM
ORDER BY 
    TOTAL_GOALS DESC
LIMIT 1;

-- 46.	Which players assisted the most goals in matches where their team lost(you can include 3)?
-- Step 1: Identify matches where the player's team lost
WITH LosingMatches AS (
    SELECT 
        g.GOAL_ID,
        g.PID AS PLAYER_ID,
        g.ASSIST,
        m.HOME_TEAM,
        m.AWAY_TEAM,
        m.HOME_TEAM_SCORE,
        m.AWAY_TEAM_SCORE,
        CASE 
            WHEN g.PID IN (SELECT PLAYER_ID FROM players WHERE TEAM = m.HOME_TEAM) 
                 AND m.HOME_TEAM_SCORE < m.AWAY_TEAM_SCORE THEN 'LOST'
            WHEN g.PID IN (SELECT PLAYER_ID FROM players WHERE TEAM = m.AWAY_TEAM) 
                 AND m.AWAY_TEAM_SCORE < m.HOME_TEAM_SCORE THEN 'LOST'
            ELSE 'NOT_LOST'
        END AS TEAM_RESULT
    FROM 
        goals g
    JOIN 
        matches m ON g.MATCH_ID = m.MATCH_ID
),

-- Step 2: Filter for lost matches and calculate assists
AssistsInLostMatches AS (
    SELECT 
        ASSIST AS PLAYER_ID,
        COUNT(GOAL_ID) AS TOTAL_ASSISTS
    FROM 
        LosingMatches
    WHERE 
        TEAM_RESULT = 'LOST' AND ASSIST IS NOT NULL
    GROUP BY 
        ASSIST
)

-- Step 3: Get top 3 players with the most assists
SELECT 
    p.PLAYER_ID,
    p.FIRST_NAME,
    p.LAST_NAME,
    a.TOTAL_ASSISTS
FROM 
    AssistsInLostMatches a
JOIN 
    players p ON a.PLAYER_ID = p.PLAYER_ID
ORDER BY 
    TOTAL_ASSISTS DESC
LIMIT 3;

-- 47.	What is the total number of goals scored by players who are positioned as defenders?
SELECT COUNT(*) AS total_goals
FROM Goals AS g
JOIN Players AS p ON g.PID = p.PLAYER_ID
WHERE p.POSITION = 'Defender';

-- 48.	Which players scored goals in matches that were held in stadiums with a capacity over 60,000?
SELECT DISTINCT p.PLAYER_ID, p.FIRST_NAME, p.LAST_NAME
FROM Goals AS g
JOIN Players AS p ON g.PID = p.PLAYER_ID
JOIN Matches AS m ON g.MATCH_ID = m.MATCH_ID
WHERE m.ATTENDANCE > 60000;

-- 49.	How many goals were scored in matches played in cities with specific stadiums in a season?
 -- Replace ('Etihad Stadium', 'Jan Breydel Stadion') with the desired stadium names
SELECT m.SEASON, m.STADIUM, COUNT(g.GOAL_ID) AS total_goals
FROM Matches AS m
JOIN Goals AS g ON m.MATCH_ID = g.MATCH_ID
WHERE m.SEASON = '2021-2022' -- Specify the desired season
AND m.STADIUM IN ('Etihad Stadium', 'Jan Breydel Stadion') -- Replace with the desired stadium names
GROUP BY m.SEASON, m.STADIUM;

-- 50.	Which players scored goals in matches with the highest attendance (over 100,000)?
SELECT DISTINCT p.PLAYER_ID, p.FIRST_NAME, p.LAST_NAME
FROM Goals AS g
JOIN Players AS p ON g.PID = p.PLAYER_ID
JOIN Matches AS m ON g.MATCH_ID = m.MATCH_ID
WHERE m.ATTENDANCE > 100000;




