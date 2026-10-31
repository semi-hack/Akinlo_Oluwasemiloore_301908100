# Portfolio 4 — NoSQL and Advanced Data Models

I used MongoDB collection match_event_streams for match_started and score_submitted events. These are fictional event examples based on match, game, player, leaderboard_score.

## Document model

| Field | Meaning |
| --- | --- |
| _id | Unique string event ID |
| eventType | One of the two selected case event labels |
| occurredAt | Native BSON Date; sample timestamps are in 2030 |
| source | Original entity, primary key and saved JSON snapshot |
| embedded | Linked record snapshots read with the event |
| references | Keys for linked sources kept outside the embedded snapshots |
| details | Event metadata whose fields vary |

Related source details are stored as snapshots with the event. This makes an event readable in one document. It duplicates some information, and later SQL changes do not automatically update the snapshots. PostgreSQL continues to enforce the relational rules.

## Example document

```javascript
{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "match_started",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "leaderboard_score",
        "key": {
            "score_id": 401
        },
        "snapshot": {
            "score_id": 401,
            "match_id": 301,
            "player_id": 101,
            "points": 1250,
            "submitted_at": "2026-10-29T14:30:00Z"
        }
    },
    "embedded": {},
    "references": {
        "match": [
            {
                "key": {
                    "match_id": 301
                },
                "via": [
                    "leaderboard_score.match_id → match"
                ]
            }
        ],
        "game": [
            {
                "key": {
                    "game_id": 201
                },
                "via": [
                    "leaderboard_score.match_id → match.game_id → game"
                ]
            }
        ],
        "player": [
            {
                "key": {
                    "player_id": 101
                },
                "via": [
                    "leaderboard_score.player_id → player"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}
```

## Queries and results

| Query | Returned documents |
| --- | --- |
| Find the first sample event type (up to five documents). | 1 |
| Find events for the first source record using nested key fields (up to five). | 2 |
| Find events in the sample time range using a MongoDB Date filter (up to five). | 2 |
| Count documents for each event type. | 2 |

## 1. Find the first sample event type (up to five documents).

```javascript
db.getCollection("match_event_streams").find({"eventType":"match_started"}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "match_started",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "score_id": 401
    }
  }
]
```

## 2. Find events for the first source record using nested key fields (up to five).

```javascript
db.getCollection("match_event_streams").find({"source.key.score_id":401}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "match_started",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "score_id": 401
    }
  },
  {
    "_id": "event_000002",
    "eventType": "score_submitted",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "score_id": 401
    }
  }
]
```

## 3. Find events in the sample time range using a MongoDB Date filter (up to five).

```javascript
db.getCollection("match_event_streams").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "match_started",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "score_id": 401
    }
  },
  {
    "_id": "event_000002",
    "eventType": "score_submitted",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "score_id": 401
    }
  }
]
```

## 4. Count documents for each event type.

```javascript
db.getCollection("match_event_streams").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray();
```

| _id | documentCount |
| --- | --- |
| match_started | 1 |
| score_submitted | 1 |

## Validation and suitability

MongoDB inserted 2 documents. An invalid date type was rejected with code 121 and a repeated event ID with 11000. The collection still contained 2 valid documents. The compound eventType/occurredAt index supports those access fields; this exercise does not measure its speed.

The details field can vary across event types, while the common fields have a validator. Events can be added as separate documents rather than growing one large history record.

## Run the script

Connect mongosh to a fresh exercise database and run Akinlo_Oluwasemiloore_301908100_P4_MongoDB.js. It selects portfolio_nosql, creates the collection, inserts the sample documents and displays the query results. [Implementation evidence](screenshots/Akinlo_Oluwasemiloore_301908100_P4_DocumentsAndQueries.png).

## References

- [MongoDB — data modelling](https://www.mongodb.com/docs/manual/data-modeling/)

