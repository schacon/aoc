DROP TABLE IF EXISTS raw;
CREATE TABLE raw(line TEXT);

.import input_final.txt raw

DROP TABLE IF EXISTS nodes;
CREATE TABLE nodes (
  row   INTEGER,
  col   INTEGER,
  entry TEXT
);

INSERT INTO nodes (row, col, entry)
WITH RECURSIVE
  grid AS (
    -- Start with each line, use rowid-1 as 0-based row index,
    -- and column index 1 (SQLite strings are 1-based)
    SELECT rowid - 1 AS row,
           line,
           1       AS col
    FROM raw

    UNION ALL

    -- Advance column index until we reach the end of the line
    SELECT row,
           line,
           col + 1
    FROM grid
    WHERE col < length(line)
  )
SELECT
  row,                 -- 0-based row index
  col - 1 AS col,      -- convert to 0-based column index
  substr(line, col, 1) AS entry
FROM grid;