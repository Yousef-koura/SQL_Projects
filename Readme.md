# SQL Documentation
### A Complete Reference Guide for SQL Server

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Data Types](#2-data-types)
3. [Database & Schema Management](#3-database--schema-management)
4. [Table Creation](#4-table-creation)
5. [SELECT Queries](#5-select-queries)
6. [Filtering & Sorting](#6-filtering--sorting)
7. [Aggregate Functions](#7-aggregate-functions)
8. [Conditional Logic](#8-conditional-logic)
9. [SQL Joins](#9-sql-joins)
10. [Query Execution Order](#10-query-execution-order)

---

## 1. Introduction

A **database** is an organized collection of structured data stored in tables made up of rows and columns.

SQL (Structured Query Language) is the standard language for managing and manipulating relational databases. SQL commands are grouped into 5 main types:

<p align="center">
  <img src= "https://miro.medium.com/v2/resize:fit:4800/format:webp/0*6TN3iYNlerAnPqXq.png"
       alt="SQL Server Sample Database" 
       width="600"/>
</p>

| Type | Full Name | Purpose |
|------|-----------|---------|
| DDL | Data Definition Language | Create, alter, drop database objects |
| DML | Data Manipulation Language | Insert, update, delete data |
| DQL | Data Query Language | Select / retrieve data |
| DCL | Data Control Language | Grant and revoke permissions |
| TCL | Transaction Control Language | Manage transactions |

---

## 2. Data Types

| Data Type | Description | Example |
|-----------|-------------|---------|
| `INT` | Whole number | `42`, `-7` |
| `DECIMAL(p, s)` | Decimal number with precision `p` and scale `s` | `DECIMAL(10,4)` → `1234.5678` |
| `VARCHAR(n)` | Variable-length string up to `n` characters | `VARCHAR(100)` |
| `BLOB` | Binary Large Object — stores files, images, etc. | Images, documents |
| `DATE` | Date value | `YYYY-MM-DD` |
| `TIMESTAMP` | Date and time value | `YYYY-MM-DD HH:MM:SS` |

---

## 3. Database & Schema Management

### Database

```sql
-- Create a database
CREATE DATABASE database_name;

-- Delete a database
DROP DATABASE database_name;
```

### Schema

A **schema** is a logical grouping that organizes tables and defines their relationships.

<p align="center">
  <img src= "https://www.sqlservertutorial.net/wp-content/uploads/SQL-Server-Sample-Database.png"
       alt="SQL Server Sample Database" 
       width="600"/>
</p>

```sql
-- Create a schema
CREATE SCHEMA schema_name;

-- Delete a schema
DROP SCHEMA schema_name;
```

---

## 4. Table Creation

```sql
CREATE TABLE [database_name.][schema_name.]table_name (
    pk_column   data_type PRIMARY KEY,
    column_1    data_type NOT NULL,
    column_2    data_type,
    ...
    table_constraints
);
```

**Example:**

```sql
CREATE TABLE student (
    student_id  INT           PRIMARY KEY,
    name        VARCHAR(20)   NOT NULL,
    major       VARCHAR(30)
);
```

### Common Column Constraints

| Constraint | Description |
|------------|-------------|
| `PRIMARY KEY` | Uniquely identifies each row |
| `NOT NULL` | Column cannot be empty |
| `UNIQUE` | All values must be different |
| `DEFAULT value` | Sets a default value if none provided |
| `FOREIGN KEY` | Links to a primary key in another table |

---

## 5. SELECT Queries

### 5.1 Select All Columns

```sql
SELECT * FROM table_name;
```

### 5.2 Select Specific Columns

```sql
SELECT column1, column2 FROM table_name;
```

**Example:**
```sql
SELECT industry, title FROM movies;
```

### 5.3 Select with WHERE Clause

```sql
SELECT * FROM table_name WHERE condition;
```

**Example:**
```sql
SELECT * FROM movies WHERE industry = 'Hollywood';
```

### 5.4 Select Distinct Values

```sql
SELECT DISTINCT column1 FROM table_name;
```

**Example:**
```sql
SELECT DISTINCT industry FROM movies;
```

### 5.5 Wildcard Search (LIKE)

```sql
SELECT * FROM table_name WHERE column LIKE '%pattern%';
```

**Example:**
```sql
SELECT * FROM movies WHERE title LIKE '%Thor%';
```

| Wildcard | Meaning |
|----------|---------|
| `%` | Any sequence of characters |
| `_` | Any single character |

### 5.6 Handle NULL / Empty Values

```sql
-- Check for NULL (numeric or unset)
SELECT * FROM movies WHERE imdb_rating IS NULL;

-- Exclude NULLs
SELECT * FROM movies WHERE imdb_rating IS NOT NULL;

-- Check for empty string
SELECT * FROM movies WHERE studio = '';
```

---

## 6. Filtering & Sorting

### 6.1 Comparison Operators

```sql
SELECT * FROM movies WHERE imdb_rating >= 9;
SELECT * FROM movies WHERE imdb_rating BETWEEN 6 AND 8;
SELECT * FROM movies WHERE release_year IN (2020, 2021, 2022);
```

### 6.2 ORDER BY

```sql
-- Ascending (low to high)
SELECT * FROM movies ORDER BY imdb_rating ASC;

-- Descending (high to low)
SELECT * FROM movies ORDER BY imdb_rating DESC;
```

### 6.3 LIMIT & OFFSET

> **Note:** In SQL Server, use `TOP` instead of `LIMIT`.

```sql
-- MySQL / PostgreSQL
SELECT * FROM movies ORDER BY imdb_rating DESC LIMIT 5;
SELECT * FROM movies ORDER BY imdb_rating DESC LIMIT 5 OFFSET 1;

-- SQL Server equivalent
SELECT TOP 5 * FROM movies ORDER BY imdb_rating DESC;
```

### 6.4 COUNT with WHERE

```sql
SELECT COUNT(*) FROM movies WHERE industry = 'Hollywood';
```

---

## 7. Aggregate Functions

| Function | Description |
|----------|-------------|
| `COUNT(*)` | Number of rows |
| `SUM(col)` | Total of a numeric column |
| `AVG(col)` | Average value |
| `MIN(col)` | Smallest value |
| `MAX(col)` | Largest value |
| `ROUND(val, n)` | Round to `n` decimal places |

**Example — Combined aggregates:**

```sql
SELECT
    MAX(imdb_rating)        AS Max,
    MIN(imdb_rating)        AS Min,
    ROUND(AVG(imdb_rating), 2) AS Average
FROM movies;
```

### 7.1 GROUP BY

Groups rows sharing the same value in a column.

```sql
SELECT column1, COUNT(*) FROM table_name GROUP BY column1;
```

**Example:**
```sql
SELECT
    industry,
    COUNT(*)               AS count,
    ROUND(AVG(imdb_rating), 1) AS average
FROM movies
GROUP BY industry
ORDER BY count DESC;
```

### 7.2 HAVING

Filters groups after `GROUP BY` (like `WHERE` but for groups).

```sql
SELECT column1, COUNT(*)
FROM table_name
GROUP BY column1
HAVING COUNT(*) > 1;
```

**Example:**
```sql
SELECT release_year, COUNT(*) AS count
FROM movies
GROUP BY release_year
HAVING count > 2
ORDER BY count DESC;
```

---

## 8. Conditional Logic

### 8.1 IF Statement

```sql
SELECT *, IF(condition, value_if_true, value_if_false) AS alias
FROM table_name;
```

**Example:**
```sql
SELECT *,
    IF(currency = 'USD', revenue * 77, revenue) AS revenue_INR
FROM financials;
```

### 8.2 CASE Statement

Used for multiple conditions (like if / else if / else).

```sql
SELECT column1,
    CASE
        WHEN condition1 THEN 'Result1'
        WHEN condition2 THEN 'Result2'
        ELSE 'DefaultResult'
    END AS new_column_name
FROM table_name;
```

**Example:**
```sql
SELECT *,
    CASE
        WHEN unit = 'thousands' THEN ROUND(revenue / 1000, 1)
        WHEN unit = 'billions'  THEN ROUND(revenue * 1000, 1)
        ELSE revenue
    END AS revenue_ml
FROM financials;
```

---

## 9. SQL Joins

Joins combine rows from two or more tables based on a related column.

<p align="center">
  <img src= "https://i.ytimg.com/vi/Yh4CrPHVBdE/maxresdefault.jpg"
       alt="SQL Server Sample Database" 
       width="600"/>
</p>

### 9.1 INNER JOIN

Returns only rows that have matching values in **both** tables.

```sql
SELECT t1.*, t2.*
FROM table1 t1
INNER JOIN table2 t2 ON t1.column = t2.column;
```

**Example:**
```sql
SELECT m.movie_id, title, budget, revenue, currency, unit
FROM movies m
INNER JOIN financials f ON m.movie_id = f.movie_id;
```

### 9.2 LEFT JOIN

Returns **all rows** from the left table, and matching rows from the right. Unmatched right rows show `NULL`.

```sql
SELECT t1.*, t2.*
FROM table1 t1
LEFT JOIN table2 t2 ON t1.column = t2.column;
```

### 9.3 RIGHT JOIN

Returns **all rows** from the right table, and matching rows from the left. Unmatched left rows show `NULL`.

```sql
SELECT t1.*, t2.*
FROM table1 t1
RIGHT JOIN table2 t2 ON t1.column = t2.column;
```

### 9.4 FULL JOIN (via UNION)

Returns all rows from both tables. Unmatched rows show `NULL` on either side.

```sql
SELECT m.movie_id, title, budget, revenue, currency, unit
FROM movies m LEFT JOIN financials f ON m.movie_id = f.movie_id
UNION
SELECT f.movie_id, title, budget, revenue, currency, unit
FROM movies m RIGHT JOIN financials f ON m.movie_id = f.movie_id;
```

### Join Comparison Table

| Join Type | Left Table | Right Table | Unmatched Rows |
|-----------|-----------|------------|----------------|
| `INNER JOIN` | Matching only | Matching only | Excluded |
| `LEFT JOIN` | All rows | Matching only | NULL on right |
| `RIGHT JOIN` | Matching only | All rows | NULL on left |
| `FULL JOIN` | All rows | All rows | NULL on either side |

---

## 10. Query Execution Order

SQL does **not** execute in the order it is written. The actual execution order is:

```
FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY
```

| Step | Clause | What It Does |
|------|--------|-------------|
| 1 | `FROM` | Identifies the source table(s) |
| 2 | `WHERE` | Filters individual rows |
| 3 | `GROUP BY` | Groups filtered rows |
| 4 | `HAVING` | Filters groups |
| 5 | `SELECT` | Selects columns / computes values |
| 6 | `ORDER BY` | Sorts the final result |

**Full query example using all clauses:**

```sql
SELECT release_year, COUNT(*) AS count
FROM movies
WHERE industry = 'Hollywood'
GROUP BY release_year
HAVING COUNT(*) > 2
ORDER BY count DESC;
```

---

*Documentation compiled from personal SQL study notes.*
