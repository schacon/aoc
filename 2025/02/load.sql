DROP TABLE IF EXISTS raw;
CREATE TABLE raw(line TEXT);

-- Import the file into the table
-- In sqlite CLI:
.import input_final.txt raw

DROP TABLE IF EXISTS ranges;
CREATE TABLE ranges (
    id INTEGER PRIMARY KEY,      -- auto-incrementing ID
    start_range INTEGER,
    end_range INTEGER
);

INSERT INTO ranges(start_range, end_range)
WITH RECURSIVE
input(line) AS (
    SELECT line FROM raw LIMIT 1
),
split_csv(pos, segment, rest) AS (
    SELECT
        1,
        substr(line, 1, instr(line || ',', ',') - 1),
        substr(line, instr(line || ',', ',') + 1)
    FROM input

    UNION ALL

    SELECT
        pos + 1,
        substr(rest, 1, instr(rest || ',', ',') - 1),
        substr(rest, instr(rest || ',', ',') + 1)
    FROM split_csv
    WHERE rest <> ''
)
SELECT
    CAST(substr(segment, 1, instr(segment, '-') - 1) AS INTEGER),
    CAST(substr(segment, instr(segment, '-') + 1) AS INTEGER)
FROM split_csv;