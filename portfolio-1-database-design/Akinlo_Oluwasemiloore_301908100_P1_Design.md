# Real-time Game Leaderboard — database design

My case study records player, game, match, leaderboard_score.

## Users

- Players submitting match scores
- Leaderboard viewers
- Game organizers managing matches

## Main operations

- Register players and games
- Record a player's final score for a match
- View match results and aggregated game rankings

## Entities

| Entity | Information stored |
| --- | --- |
| player | A registered leaderboard participant. |
| game | A game for which matches and rankings are recorded. |
| match | A dated occurrence of one game. |
| leaderboard_score | One player's final score and submission time for one match. |

## player

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| player_id | BIGINT | PK | Yes |
| display_name | TEXT |  | Yes |
| region | TEXT |  | Yes |
| joined_on | DATE |  | Yes |


## game

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| game_id | BIGINT | PK | Yes |
| title | TEXT |  | Yes |
| mode | TEXT |  | Yes |
| is_active | BOOLEAN |  | Yes |


## match

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| match_id | BIGINT | PK | Yes |
| game_id | BIGINT | FK | Yes |
| played_on | DATE |  | Yes |
| status | TEXT |  | Yes |
- game_id → game.game_id

## leaderboard_score

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| score_id | BIGINT | PK | Yes |
| match_id | BIGINT | FK | Yes |
| player_id | BIGINT | FK | Yes |
| points | INTEGER |  | Yes |
| submitted_at | TIMESTAMPTZ |  | Yes |
- match_id → match.match_id
- player_id → player.player_id
- Unique key: (match_id, player_id).

## Relationships and business rules

- A player may have only one final score entry for a given match.
- A submitted final score must be a nonnegative integer.
- Every score must refer to an existing match.
- Every score must refer to an existing player.
- Every match must refer to an existing game.

## Assumptions

- Each match belongs to one game, and each score records one player's final result for one match.
- A player can have at most one score entry per match; a later correction updates that entry rather than creating another.
- Only nonnegative integer scores are accepted.
- For the normalization example, use leaderboard_score as the root: retain match_id and score-specific facts there, keep game_id in match, and keep game details in game rather than copying them into the score row.

