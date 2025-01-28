-- 51.	What is the average number of goals scored by each team in the first 30 minutes of a match?
SELECT team, AVG(goals) AS avg_goals
FROM (
    SELECT m.HOME_TEAM AS team, COUNT(g.GOAL_ID) AS goals
    FROM Goals AS g
    JOIN Matches AS m ON g.MATCH_ID = m.MATCH_ID
    WHERE g.DURATION <= 30
    GROUP BY m.HOME_TEAM

    UNION ALL

    SELECT m.AWAY_TEAM AS team, COUNT(g.GOAL_ID) AS goals
    FROM Goals AS g
    JOIN Matches AS m ON g.MATCH_ID = m.MATCH_ID
    WHERE g.DURATION <= 30
    GROUP BY m.AWAY_TEAM
) AS team_goals
GROUP BY team;

-- 52.	Which stadium had the highest average score difference between home and away teams?
SELECT STADIUM, AVG(ABS(HOME_TEAM_SCORE - AWAY_TEAM_SCORE)) AS avg_score_difference
FROM Matches
GROUP BY STADIUM
ORDER BY avg_score_difference DESC
LIMIT 1;

-- 53.	How many players scored in every match they played during a given season?
-- Specify the desired season
SELECT p.PLAYER_ID, p.FIRST_NAME, p.LAST_NAME
FROM Players AS p
JOIN (
    SELECT g.PID, 
           COUNT(DISTINCT g.MATCH_ID) AS matches_scored, 
           (SELECT COUNT(DISTINCT m.MATCH_ID)
            FROM Matches AS m
            WHERE m.SEASON = '2021-2022'
              AND m.MATCH_ID IN (SELECT MATCH_ID FROM Goals WHERE PID = g.PID)) AS matches_played
    FROM Goals AS g
    JOIN Matches AS m ON g.MATCH_ID = m.MATCH_ID
    WHERE m.SEASON = '2021-2022' -- Specify the desired season
    GROUP BY g.PID
    HAVING COUNT(DISTINCT g.MATCH_ID) = 
           (SELECT COUNT(DISTINCT m.MATCH_ID)
            FROM Matches AS m
            WHERE m.SEASON = '2021-2022'
              AND m.MATCH_ID IN (SELECT MATCH_ID FROM Goals WHERE PID = g.PID))
) AS scoring_stats ON p.PLAYER_ID = scoring_stats.PID;

-- 54.	Which teams won the most matches with a goal difference of 3 or more in the 2021-2022 season?
SELECT winner, COUNT(*) AS wins
FROM (
    SELECT 
        CASE 
            WHEN HOME_TEAM_SCORE > AWAY_TEAM_SCORE THEN HOME_TEAM
            WHEN AWAY_TEAM_SCORE > HOME_TEAM_SCORE THEN AWAY_TEAM
        END AS winner
    FROM Matches
    WHERE SEASON = '2021-2022'
      AND ABS(HOME_TEAM_SCORE - AWAY_TEAM_SCORE) >= 3
) AS match_winners
GROUP BY winner
ORDER BY wins DESC
LIMIT 1;

-- 55.	Which player from a specific country has the highest goals per match ratio?
SELECT p.PLAYER_ID, p.FIRST_NAME, p.LAST_NAME, p.NATIONALITY, 
       (total_goals * 1.0 / total_matches) AS goals_per_match_ratio
FROM Players AS p
JOIN (
    SELECT g.PID, 
           COUNT(g.GOAL_ID) AS total_goals, 
           (SELECT COUNT(DISTINCT m.MATCH_ID)
            FROM Matches AS m
            WHERE m.MATCH_ID IN (SELECT g.MATCH_ID FROM Goals WHERE PID = g.PID)) AS total_matches
    FROM Goals AS g
    GROUP BY g.PID
) AS stats ON p.PLAYER_ID = stats.PID
WHERE p.NATIONALITY = 'CountryName' -- Replace with the specific country
ORDER BY goals_per_match_ratio DESC
LIMIT 1;



