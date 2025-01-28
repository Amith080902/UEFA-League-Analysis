-- 10. What was the highest-scoring match in a particular season?
-- Replace '2016-2017' with the desired season
SELECT season, match_id, Home_team_score
FROM matches 
WHERE season = '2016-2017'
GROUP BY season, match_id, Home_team_score
ORDER BY Home_team_score desc 
Limit 1;

-- 11. How many matches ended in a draw in a given season?
-- Replace '2016-2017' with the desired season
SELECT match_id, HOME_TEAM_SCORE, AWAY_TEAM_SCORE
FROM matches
WHERE  season = '2016-2017' and HOME_TEAM_SCORE=AWAY_TEAM_SCORE
GROUP BY season, match_id, HOME_TEAM_SCORE, AWAY_TEAM_SCORE
ORDER BY Home_team_score desc;

-- 12. Which team had the highest average score (home and away) in the season 2021-2022?
SELECT team_name, AVG(total_score) AS average_score
FROM (SELECT home_team AS team_name, HOME_TEAM_SCORE AS total_score
    FROM matches WHERE season = '2021-2022' UNION ALL
    SELECT away_team AS team_name, away_team_score AS total_score
    FROM matches WHERE season = '2021-2022') AS combined_scores
GROUP BY team_name
ORDER BY average_score DESC
LIMIT 1;

-- 13. How many penalty shootouts occurred in a each season?
SELECT season, COUNT(PENALTY_SHOOT_OUT) AS no_of_penalty_shootouts
FROM matches
where PENALTY_SHOOT_OUT > 0
GROUP BY season
ORDER BY season;

-- 14. What is the average attendance for home teams in the 2021-2022 season?
SELECT home_team, AVG(attendance) AS average_attendance
FROM matches
WHERE season = '2021-2022'
GROUP BY home_team
ORDER BY average_attendance DESC;
 
-- 15.Which stadium hosted the most matches in a each season?
SELECT season, stadium, COUNT(*) AS matches_hosted
FROM matches
GROUP BY season, stadium
ORDER BY season, matches_hosted DESC;

-- 16.What is the distribution of matches played in different countries in a season?
SELECT a.season, b.country, b.home_stadium as stadium, COUNT(*) AS total_matches
FROM matches as a inner join teams as b
ON a.stadium=b.home_stadium
GROUP BY season, country, home_stadium
ORDER BY season, total_matches DESC;

-- 17. What was the most common result in matches (home win, away win, draw)?
SELECT result, COUNT(*) AS total_occurrences
FROM (
    SELECT 
        CASE 
            WHEN home_team_score > away_team_score THEN 'Home Win'
            WHEN home_team_score < away_team_score THEN 'Away Win'
            ELSE 'Draw'
        END AS result
    FROM matches
) AS match_results
GROUP BY result
ORDER BY total_occurrences DESC;

