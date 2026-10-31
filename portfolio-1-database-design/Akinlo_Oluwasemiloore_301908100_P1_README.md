# Portfolio 1 — Database Design and Modelling

I organised the data into player, game, match, leaderboard_score. The design document explains the fields, keys, relationships and business rules. The normalisation document shows the sample tables at 1NF, 2NF and 3NF.

## Database checks

| Table | Rows |
| --- | --- |
| player | 2 |
| game | 1 |
| match | 2 |
| leaderboard_score | 1 |

The 10 invalid inserts were rejected at their expected constraints, and the valid sample rows remained unchanged.

## Files

- [Design](Akinlo_Oluwasemiloore_301908100_P1_Design.md)
- [ER diagram](Akinlo_Oluwasemiloore_301908100_P1_ERDiagram.md)
- [Normalisation](Akinlo_Oluwasemiloore_301908100_P1_Normalisation.md)
- [Schema](Akinlo_Oluwasemiloore_301908100_P1_Schema.sql)
- [Sample data](Akinlo_Oluwasemiloore_301908100_P1_SampleData.sql)
- [Constraint tests](Akinlo_Oluwasemiloore_301908100_P1_ConstraintTests.sql)
- [Table and constraint evidence](screenshots/Akinlo_Oluwasemiloore_301908100_P1_DatabaseResults.png)

## Run the SQL

Create a fresh PostgreSQL database. Run the schema first, then the sample data. Run the deliberately invalid statements in ConstraintTests.sql individually outside a transaction; each is expected to produce an error.

## References

- [PostgreSQL — constraints](https://www.postgresql.org/docs/17/ddl-constraints.html)

