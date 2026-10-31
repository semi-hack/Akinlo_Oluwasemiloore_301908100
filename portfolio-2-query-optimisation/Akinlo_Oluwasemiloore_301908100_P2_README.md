# Real-time Game Leaderboard — SQL queries

## 1. Show related leaderboard_score, player, match, game records (up to 20).

```sql
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
```

| leaderboard_score_score_id | leaderboard_score_points | player_player_id | player_display_name | match_match_id | match_played_on | game_game_id | game_title |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 401 | 1250 | 101 | Avery Chen | 301 | 2026-10-29 | 201 | Sky Circuit |

## 2. Find match records where game_id matches 201 (up to 20).

```sql
SELECT * FROM portfolio."match"
WHERE "game_id" IS NOT DISTINCT FROM 201
ORDER BY "match_id"
LIMIT 20;
```

| match_id | game_id | played_on | status |
| --- | --- | --- | --- |
| 301 | 201 | 2026-10-29 | completed |
| 302 | 201 | 2026-10-30 | completed |

## 3. Count leaderboard_score records for each match_id (up to 20 groups).

```sql
SELECT "match_id", count(*) AS record_count
FROM portfolio."leaderboard_score"
GROUP BY "match_id"
ORDER BY record_count DESC, "match_id" NULLS LAST
LIMIT 20;
```

| match_id | record_count |
| --- | --- |
| 301 | 1 |

## 4. Find leaderboard_score records where submitted_at matches "2026-10-29T14:30:00Z" (up to 20).

```sql
SELECT * FROM portfolio."leaderboard_score"
WHERE "submitted_at" IS NOT DISTINCT FROM '2026-10-29T14:30:00Z'
ORDER BY "score_id"
LIMIT 20;
```

| score_id | match_id | player_id | points | submitted_at |
| --- | --- | --- | --- | --- |
| 401 | 301 | 101 | 1250 | 2026-10-29T14:30:00+00:00 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 1.006 | 0.983, 1.006, 1.013 | Sort → Seq Scan | 112 |
| After index | 0.189 | 0.189, 0.192, 0.189 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 25 |

The median execution time changed from 1.006 ms to 0.189 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=0.956..0.957 rows=20 loops=1)
  Seq Scan on leaderboard_score (actual time=0.014..0.923 rows=20 loops=1)
Planning Time: 0.383 ms
Execution Time: 0.983 ms
```

### Before index, run 2

```text
Sort (actual time=0.98..0.982 rows=20 loops=1)
  Seq Scan on leaderboard_score (actual time=0.014..0.946 rows=20 loops=1)
Planning Time: 0.393 ms
Execution Time: 1.006 ms
```

### Before index, run 3

```text
Sort (actual time=0.985..0.987 rows=20 loops=1)
  Seq Scan on leaderboard_score (actual time=0.015..0.951 rows=20 loops=1)
Planning Time: 0.393 ms
Execution Time: 1.013 ms
```

### After index, run 1

```text
Sort (actual time=0.13..0.132 rows=20 loops=1)
  Bitmap Heap Scan on leaderboard_score (actual time=0.028..0.095 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.014..0.015 rows=20 loops=1)
Planning Time: 0.606 ms
Execution Time: 0.189 ms
```

### After index, run 2

```text
Sort (actual time=0.135..0.137 rows=20 loops=1)
  Bitmap Heap Scan on leaderboard_score (actual time=0.028..0.099 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.014..0.015 rows=20 loops=1)
Planning Time: 0.587 ms
Execution Time: 0.192 ms
```

### After index, run 3

```text
Sort (actual time=0.131..0.133 rows=20 loops=1)
  Bitmap Heap Scan on leaderboard_score (actual time=0.028..0.096 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.014..0.015 rows=20 loops=1)
Planning Time: 0.602 ms
Execution Time: 0.189 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Akinlo_Oluwasemiloore_301908100_P2_Queries.sql, then Akinlo_Oluwasemiloore_301908100_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Akinlo_Oluwasemiloore_301908100_P2_QueryResults.png) · [Index comparison](screenshots/Akinlo_Oluwasemiloore_301908100_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

