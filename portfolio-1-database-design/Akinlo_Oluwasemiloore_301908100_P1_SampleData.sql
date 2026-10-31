-- Fictional sample records for Real-time Game Leaderboard.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."player" ("player_id", "display_name", "region", "joined_on") VALUES (101, 'Avery Chen', 'west', '2026-10-01');
INSERT INTO portfolio."player" ("player_id", "display_name", "region", "joined_on") VALUES (102, 'Morgan Lee', 'east', '2026-10-02');
INSERT INTO portfolio."game" ("game_id", "title", "mode", "is_active") VALUES (201, 'Sky Circuit', 'ranked', TRUE);
INSERT INTO portfolio."match" ("match_id", "game_id", "played_on", "status") VALUES (301, 201, '2026-10-29', 'completed');
INSERT INTO portfolio."match" ("match_id", "game_id", "played_on", "status") VALUES (302, 201, '2026-10-30', 'completed');
INSERT INTO portfolio."leaderboard_score" ("score_id", "match_id", "player_id", "points", "submitted_at") VALUES (401, 301, 101, 1250, '2026-10-29T14:30:00Z');
COMMIT;
