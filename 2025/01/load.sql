-- sqlite3 mydb.sqlite < load.sql

-- Drop and recreate staging table
DROP TABLE IF EXISTS raw;
CREATE TABLE raw (line TEXT);

-- Import raw lines
.import final_input.txt raw

-- Drop and recreate final table
DROP TABLE IF EXISTS moves;
CREATE TABLE moves (
    id INTEGER PRIMARY KEY,      -- auto-incrementing ID
    dir TEXT,
    amount INTEGER
);

-- Transform and insert
INSERT INTO moves (dir, amount)
SELECT
    SUBSTR(line, 1, 1) AS dir,
    CAST(SUBSTR(line, 2) AS INT) AS amount
FROM raw;
