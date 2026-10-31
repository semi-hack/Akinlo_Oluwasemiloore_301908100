# Real-time Game Leaderboard — ER diagram

```mermaid
erDiagram
    direction LR
    player {
        bigint player_id PK
        text display_name
        text region
        date joined_on
    }
    game {
        bigint game_id PK
        text title
        text mode
        boolean is_active
    }
    match {
        bigint match_id PK
        bigint game_id FK
        date played_on
        text status
    }
    leaderboard_score {
        bigint score_id PK
        bigint match_id FK
        bigint player_id FK
        integer points
        timestamptz submitted_at
    }
    game ||--o{ match : "game_id"
    match ||--o{ leaderboard_score : "match_id"
    player ||--o{ leaderboard_score : "player_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Akinlo_Oluwasemiloore_301908100_ERDiagram.png)
