-- Show related leaderboard_score, player, match, game records (up to 20).
SELECT t0."score_id" AS "leaderboard_score_score_id",
       t0."points" AS "leaderboard_score_points",
       t3."player_id" AS "player_player_id",
       t3."display_name" AS "player_display_name",
       t1."match_id" AS "match_match_id",
       t1."played_on" AS "match_played_on",
       t2."game_id" AS "game_game_id",
       t2."title" AS "game_title"
FROM portfolio."leaderboard_score" t0
JOIN portfolio."match" t1 ON t0."match_id" = t1."match_id"
JOIN portfolio."game" t2 ON t1."game_id" = t2."game_id"
JOIN portfolio."player" t3 ON t0."player_id" = t3."player_id"
ORDER BY t0."score_id", t3."player_id", t1."match_id", t2."game_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."score_id" AS "leaderboard_score_score_id",
       t0."points" AS "leaderboard_score_points",
       t3."player_id" AS "player_player_id",
       t3."display_name" AS "player_display_name",
       t1."match_id" AS "match_match_id",
       t1."played_on" AS "match_played_on",
       t2."game_id" AS "game_game_id",
       t2."title" AS "game_title"
FROM portfolio."leaderboard_score" t0
JOIN portfolio."match" t1 ON t0."match_id" = t1."match_id"
JOIN portfolio."game" t2 ON t1."game_id" = t2."game_id"
JOIN portfolio."player" t3 ON t0."player_id" = t3."player_id"
ORDER BY t0."score_id", t3."player_id", t1."match_id", t2."game_id"
LIMIT 20;

-- Find match records where game_id matches 201 (up to 20).
SELECT * FROM portfolio."match"
WHERE "game_id" IS NOT DISTINCT FROM 201
ORDER BY "match_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."match"
WHERE "game_id" IS NOT DISTINCT FROM 201
ORDER BY "match_id"
LIMIT 20;

-- Count leaderboard_score records for each match_id (up to 20 groups).
SELECT "match_id", count(*) AS record_count
FROM portfolio."leaderboard_score"
GROUP BY "match_id"
ORDER BY record_count DESC, "match_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "match_id", count(*) AS record_count
FROM portfolio."leaderboard_score"
GROUP BY "match_id"
ORDER BY record_count DESC, "match_id" NULLS LAST
LIMIT 20;

-- Find leaderboard_score records where submitted_at matches "2026-10-29T14:30:00Z" (up to 20).
SELECT * FROM portfolio."leaderboard_score"
WHERE "submitted_at" IS NOT DISTINCT FROM '2026-10-29T14:30:00Z'
ORDER BY "score_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."leaderboard_score"
WHERE "submitted_at" IS NOT DISTINCT FROM '2026-10-29T14:30:00Z'
ORDER BY "score_id"
LIMIT 20;
