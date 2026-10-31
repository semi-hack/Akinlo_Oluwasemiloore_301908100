-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. duplicate player pk. Expected: pk_player, SQLSTATE 23505.
INSERT INTO portfolio."player" ("player_id", "display_name", "region", "joined_on")
VALUES (101, 'Jordan Park', 'north', '2026-10-03');

-- 2. duplicate game pk. Expected: pk_game, SQLSTATE 23505.
INSERT INTO portfolio."game" ("game_id", "title", "mode", "is_active")
VALUES (201, 'Nova Drift', 'casual', TRUE);

-- 3. duplicate match pk. Expected: pk_match, SQLSTATE 23505.
INSERT INTO portfolio."match" ("match_id", "game_id", "played_on", "status")
VALUES (301, 201, '2026-10-31', 'completed');

-- 4. duplicate score pk. Expected: pk_leaderboard_score, SQLSTATE 23505.
INSERT INTO portfolio."leaderboard_score" ("score_id", "match_id", "player_id", "points", "submitted_at")
VALUES (401, 302, 102, 800, '2026-10-30T15:00:00Z');

-- 5. missing match game. Expected: fk_match_0, SQLSTATE 23503.
INSERT INTO portfolio."match" ("match_id", "game_id", "played_on", "status")
VALUES (303, 999, '2026-10-31', 'completed');

-- 6. missing score match. Expected: fk_leaderboard_score_0, SQLSTATE 23503.
INSERT INTO portfolio."leaderboard_score" ("score_id", "match_id", "player_id", "points", "submitted_at")
VALUES (402, 999, 102, 800, '2026-10-30T15:05:00Z');

-- 7. missing score player. Expected: fk_leaderboard_score_1, SQLSTATE 23503.
INSERT INTO portfolio."leaderboard_score" ("score_id", "match_id", "player_id", "points", "submitted_at")
VALUES (403, 302, 999, 800, '2026-10-30T15:10:00Z');

-- 8. duplicate match player score. Expected: uq_leaderboard_score_0, SQLSTATE 23505.
INSERT INTO portfolio."leaderboard_score" ("score_id", "match_id", "player_id", "points", "submitted_at")
VALUES (404, 301, 101, 1300, '2026-10-30T15:15:00Z');

-- 9. negative score points. Expected: score_points_nonnegative, SQLSTATE 23514.
INSERT INTO portfolio."leaderboard_score" ("score_id", "match_id", "player_id", "points", "submitted_at")
VALUES (405, 302, 102, -1, '2026-10-30T15:20:00Z');

-- 10. null player display name. Expected: display_name, SQLSTATE 23502.
INSERT INTO portfolio."player" ("player_id", "display_name", "region", "joined_on")
VALUES (103, NULL, 'south', '2026-10-04');
