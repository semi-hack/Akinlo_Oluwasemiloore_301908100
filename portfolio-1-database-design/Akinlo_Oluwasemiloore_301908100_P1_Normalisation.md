# Real-time Game Leaderboard — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| match_id | leaderboard_score records (list) |
| --- | --- |
| 301 | [401] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| leaderboard_score.score_id | leaderboard_score.match_id | leaderboard_score.player_id | match.match_id | match.game_id | match.status | game.game_id | game.title |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 401 | 301 | 101 | 301 | 201 | completed | 201 | Sky Circuit |

Key: score_id.

## 2NF: depend on the whole key

leaderboard_score: match_id is a proper part of candidate key (match_id, player_id), and determines match details. leaderboard_score: player_id is a proper part of candidate key (match_id, player_id), and determines player details.

## match_example

| match.match_id | match.game_id | match.status | game.game_id | game.title |
| --- | --- | --- | --- | --- |
| 301 | 201 | completed | 201 | Sky Circuit |

## leaderboard_score_example

| leaderboard_score.score_id | leaderboard_score.match_id | leaderboard_score.player_id |
| --- | --- | --- |
| 401 | 301 | 101 |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## player

| player_id | display_name | region | joined_on |
| --- | --- | --- | --- |
| 101 | Avery Chen | west | 2026-10-01 |
| 102 | Morgan Lee | east | 2026-10-02 |

## game

| game_id | title | mode | is_active |
| --- | --- | --- | --- |
| 201 | Sky Circuit | ranked | true |

## match

| match_id | game_id | played_on | status |
| --- | --- | --- | --- |
| 301 | 201 | 2026-10-29 | completed |
| 302 | 201 | 2026-10-30 | completed |

## leaderboard_score

| score_id | match_id | player_id | points | submitted_at |
| --- | --- | --- | --- | --- |
| 401 | 301 | 101 | 1250 | 2026-10-29T14:30:00+00:00 |

## Dependencies

- player: (player_id) → display_name, region, joined_on
- game: (game_id) → title, mode, is_active
- match: (match_id) → game_id, played_on, status
- leaderboard_score: (score_id) → match_id, player_id, points, submitted_at

Joining the decomposed sample tables reproduces the original 1 example rows. The design assumes the declared keys describe the relevant business dependencies.
