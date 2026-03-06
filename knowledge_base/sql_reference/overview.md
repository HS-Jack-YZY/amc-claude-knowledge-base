# AMC SQL Reference Overview

AMC SQL is a SQL dialect used within Amazon Marketing Cloud for querying advertising event data. It is based on standard SQL with specific extensions and limitations.

## Notation Conventions

AMC SQL documentation uses the following notation:

| Symbol | Meaning |
|--------|---------|
| `[ ]` | Optional element |
| `{ }` | Required element — choose one |
| `\|` | Separates alternatives (OR) |
| `...` | Preceding element can be repeated |

## Data Types

| Type | Description | Example |
|------|-------------|---------|
| `BOOLEAN` | True/false values | `TRUE`, `FALSE` |
| `TINYINT` | 8-bit signed integer | `-128` to `127` |
| `SMALLINT` | 16-bit signed integer | `-32768` to `32767` |
| `INTEGER` / `INT` | 32-bit signed integer | `-2147483648` to `2147483647` |
| `BIGINT` | 64-bit signed integer | Large integers |
| `DECIMAL(p, s)` | Fixed-point number with precision `p` and scale `s` | `DECIMAL(10, 2)` |
| `FLOAT` / `REAL` | 32-bit floating point | `3.14` |
| `DOUBLE` | 64-bit floating point | `3.14159265358979` |
| `DATE` | Calendar date (no time) | `DATE '2024-01-15'` |
| `TIMESTAMP` | Date and time | `TIMESTAMP '2024-01-15 10:30:00'` |
| `CHAR(n)` / `SYMBOL` | Fixed/variable-length character string | `'hello'` |
| `BINARY` | Binary data | Binary values |
| `ARRAY` | Ordered collection of elements | `ARRAY[1, 2, 3]` |
| `STRUCT` | Named fields with values | Structured data |
| `NULL` | Absence of a value | `NULL` |

## Logical Operators

| Operator | Description | Example |
|----------|-------------|---------|
| `AND` | Logical AND | `a > 1 AND b < 10` |
| `OR` | Logical OR | `a = 1 OR a = 2` |
| `NOT` | Logical negation | `NOT (a = 1)` |
| `IS NULL` | Test for NULL | `a IS NULL` |
| `IS NOT NULL` | Test for non-NULL | `a IS NOT NULL` |
| `=` | Equal | `a = 1` |
| `!=` / `<>` | Not equal | `a != 1` |
| `>` | Greater than | `a > 1` |
| `>=` | Greater than or equal | `a >= 1` |
| `<` | Less than | `a < 1` |
| `<=` | Less than or equal | `a <= 1` |

## AMC SQL Grammar (Simplified)

```
query:
  [WITH cte_name AS (query) [, ...]]
  SELECT [DISTINCT] select_list
  FROM table_reference [join_clause ...]
  [WHERE condition]
  [GROUP BY expression [, ...]]
  [HAVING condition]
  [LIMIT count]

select_list:
  expression [AS alias] [, ...]

table_reference:
  table_name [AS alias]
  | (query) AS alias

join_clause:
  [INNER | LEFT [OUTER] | FULL [OUTER] | CROSS] JOIN table_reference ON condition

expression:
  column_reference
  | literal
  | function_call
  | expression operator expression
  | CASE WHEN condition THEN result [ELSE result] END
  | (query)  -- scalar subquery
```

For detailed syntax of each clause, see [AMC SQL Basics](basics.md).
For available functions, see [AMC SQL Functions](functions.md).
For limitations, see [Limitations & Unsupported Features](limitations.md).
