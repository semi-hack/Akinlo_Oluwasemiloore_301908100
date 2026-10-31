-- Real-time Game Leaderboard: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."player" (
  "player_id" bigint NOT NULL,
  "display_name" text NOT NULL,
  "region" text NOT NULL,
  "joined_on" date NOT NULL,
  CONSTRAINT "pk_player" PRIMARY KEY ("player_id")
);
CREATE TABLE portfolio."game" (
  "game_id" bigint NOT NULL,
  "title" text NOT NULL,
  "mode" text NOT NULL,
  "is_active" boolean NOT NULL,
  CONSTRAINT "pk_game" PRIMARY KEY ("game_id")
);
CREATE TABLE portfolio."match" (
  "match_id" bigint NOT NULL,
  "game_id" bigint NOT NULL,
  "played_on" date NOT NULL,
  "status" text NOT NULL,
  CONSTRAINT "pk_match" PRIMARY KEY ("match_id")
);
CREATE TABLE portfolio."leaderboard_score" (
  "score_id" bigint NOT NULL,
  "match_id" bigint NOT NULL,
  "player_id" bigint NOT NULL,
  "points" bigint NOT NULL,
  "submitted_at" timestamptz NOT NULL,
  CONSTRAINT "pk_leaderboard_score" PRIMARY KEY ("score_id"),
  CONSTRAINT "uq_leaderboard_score_0" UNIQUE ("match_id", "player_id")
);
ALTER TABLE portfolio."match" ADD CONSTRAINT "fk_match_0" FOREIGN KEY ("game_id") REFERENCES portfolio."game" ("game_id");
ALTER TABLE portfolio."leaderboard_score" ADD CONSTRAINT "fk_leaderboard_score_0" FOREIGN KEY ("match_id") REFERENCES portfolio."match" ("match_id");
ALTER TABLE portfolio."leaderboard_score" ADD CONSTRAINT "fk_leaderboard_score_1" FOREIGN KEY ("player_id") REFERENCES portfolio."player" ("player_id");
ALTER TABLE portfolio."leaderboard_score" ADD CONSTRAINT "score_points_nonnegative" CHECK ("points" >= 0);
COMMIT;
