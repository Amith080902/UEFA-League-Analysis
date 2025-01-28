select * from goals
select * from matches
select * from players 
select * from stadiums
select * from teams

-- 1. Which player scored the most goals in each season?
SELECT a.season, b.PID AS player_id, COUNT(*) AS goals_scored
FROM matches as a inner join goals as b
on a.match_id=b.match_id
GROUP BY season, PID
ORDER BY season, goals_scored DESC;

-- 2. How many goals did each player score in a given season?
-- Replace '2016-2017' with the desired season
SELECT a.season, b.PID AS player_id, COUNT(*) AS goals_scored
FROM matches as a inner join goals as b
on a.match_id=b.match_id
WHERE season = '2016-2017'
GROUP BY season, PID
ORDER BY goals_scored DESC;

-- 3. What is the total number of goals scored in 'mt403' match?
SELECT COUNT(*) AS total_goals
FROM goals
WHERE MATCH_ID = 'mt403';

-- 4. Which player assisted the most goals in each season?
SELECT a.season, b.ASSIST AS player_id, COUNT(*) AS assists
FROM matches as a inner join goals as b
on a.match_id=b.match_id
WHERE ASSIST IS NOT NULL
GROUP BY season, ASSIST
ORDER BY season, assists DESC;

-- 5. Which players have scored goals in more than 10 matches?
SELECT PID AS player_id, COUNT(DISTINCT MATCH_ID) AS matches_scored
FROM goals
GROUP BY PID
HAVING COUNT(DISTINCT MATCH_ID) > 10
ORDER BY matches_scored DESC;

-- 6. What is the average number of goals scored per match in a given season?
-- Replace '2016-2017' with the desired season
SELECT a.season, COUNT(DISTINCT goal_id) AS avg_goals_per_match
FROM matches as a full join goals as b
on a.match_id=b.match_id
WHERE season = '2016-2017'
GROUP BY season
ORDER BY avg_goals_per_match;

-- 7. Which player has the most goals in a single match?
SELECT MATCH_ID, PID AS player_id, COUNT(*) AS goals_scored
FROM goals
GROUP BY MATCH_ID, PID
ORDER BY goals_scored DESC
LIMIT 1;

-- 8. Which team scored the most goals in all seasons?
SELECT a.TEAM, b.PID as player_id, COUNT(*) AS goals_scored
FROM players as a full join goals as b
ON a.player_id=b.PID
GROUP BY TEAM, PID
ORDER BY goals_scored DESC
LIMIT 5;

-- 9. Which stadium hosted the most goals scored in a single season?
SELECT season, STADIUM, COUNT(*) AS total_goals
FROM matches
GROUP BY season, STADIUM
ORDER BY total_goals DESC
LIMIT 1;
