-- 18. Which players have the highest total goals scored (including assists)?
SELECT 
    p.PLAYER_ID, 
	p.FIRST_NAME || ' ' || p.LAST_NAME AS PLAYER_NAME, 
	COUNT(g.GOAL_ID) AS TOTAL_GOALS,
    SUM(CASE WHEN g.ASSIST IS NOT NULL THEN 1 ELSE 0 END) AS TOTAL_ASSISTS,
    COUNT(g.GOAL_ID) + SUM(CASE WHEN g.ASSIST IS NOT NULL THEN 1 ELSE 0 END) AS TOTAL_CONTRIBUTIONS
FROM Players p JOIN Goals g ON p.PLAYER_ID = g.PID
GROUP BY p.PLAYER_ID, p.FIRST_NAME, p.LAST_NAME
ORDER BY TOTAL_CONTRIBUTIONS DESC
LIMIT 10;

-- 19. What is the average height and weight of players per position?
SELECT 
    POSITION, 
    CAST(AVG(HEIGHT) AS NUMERIC(10, 2)) AS AVG_HEIGHT, 
    CAST(AVG(WEIGHT) AS NUMERIC(10, 2)) AS AVG_WEIGHT
FROM Players
GROUP BY POSITION
ORDER BY POSITION;

-- 20. Which player has the most goals scored with their left foot?
SELECT 
    p.PLAYER_ID, 
    p.FIRST_NAME || ' ' || p.LAST_NAME AS PLAYER_NAME,
    COUNT(g.GOAL_ID) AS TOTAL_LEFT_FOOT_GOALS
FROM Players p JOIN Goals g ON p.PLAYER_ID = g.PID
WHERE g.GOAL_DESC ILIKE '%left foot%'
GROUP BY p.PLAYER_ID, p.FIRST_NAME, p.LAST_NAME
ORDER BY TOTAL_LEFT_FOOT_GOALS DESC
LIMIT 1;

-- 21.	What is the average age of players per team?
SELECT 
    TEAM, 
    ROUND(AVG(EXTRACT(YEAR FROM AGE(DOB))), 2) AS AVG_AGE
FROM Players
GROUP BY TEAM
ORDER BY TEAM;

-- 22.	How many players are listed as playing for a each team in a season?
SELECT 
    M.SEASON,
    P.TEAM,
    COUNT(DISTINCT P.PLAYER_ID) AS PLAYER_COUNT
FROM 
    Players P
JOIN 
    goals G ON P.PLAYER_ID = G.PID
JOIN 
    Matches M ON G.MATCH_ID = M.MATCH_ID
GROUP BY 
    M.SEASON, P.TEAM
ORDER BY 
    M.SEASON, P.TEAM;


-- 23. Which player has played in the most matches in the each season?
SELECT 
    M.SEASON,
    G.PID AS PLAYER_ID,
    CONCAT(P.FIRST_NAME, ' ', P.LAST_NAME) AS PLAYER_NAME,
    COUNT(DISTINCT G.MATCH_ID) AS MATCH_COUNT
FROM 
    goals G
JOIN 
    Players P ON G.PID = P.PLAYER_ID
JOIN 
    Matches M ON G.MATCH_ID = M.MATCH_ID
GROUP BY 
    M.SEASON, G.PID, PLAYER_NAME
ORDER BY 
    M.SEASON, MATCH_COUNT DESC;

-- 24. What is the most common position for players across all teams?
SELECT 
    POSITION,
    COUNT(*) AS POSITION_COUNT
FROM 
    Players
GROUP BY 
    POSITION
ORDER BY 
    POSITION_COUNT DESC
LIMIT 1;

-- 25. Which players have never scored a goal?
SELECT 
    P.PLAYER_ID,
    CONCAT(P.FIRST_NAME, ' ', P.LAST_NAME) AS PLAYER_NAME,
    P.TEAM
FROM 
    Players P
LEFT JOIN 
    goals G ON P.PLAYER_ID = G.PID
WHERE 
    G.PID IS NULL;

