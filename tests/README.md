# CRUD regression tests

These tests cover the current SQL Server CRUD analysis scope.

## Covered

- SELECT and JOIN
- INSERT / INSERT ... SELECT
- UPDATE / UPDATE ... FROM
- DELETE / DELETE ... FROM
- SELECT INTO
- subqueries, nested subqueries and correlated subqueries
- EXISTS / IN
- derived table traversal through the ScriptDom AST
- IF predicate + statement

The expected result is recorded in each SQL file as:

`-- EXPECT: C=...; R=...; U=...; D=...`

Run all cases from the repository root with:

```powershell
.\tests\run-crud-tests.ps1
```

## Current exclusions

CTEs, stored procedures, MERGE, dynamic SQL, views/functions/triggers and other statement-specific dependency semantics are intentionally left for later work.
