WITH RECURSIVE
expand AS (
    SELECT
        start_range AS n,
        end_range,
        start_range AS range_start
    FROM ranges

    UNION ALL

    SELECT
        n + 1,
        end_range,
        range_start
    FROM expand
    WHERE n < end_range
),
numbers AS (
    SELECT
        range_start,
        end_range,
        n,
        CAST(n AS TEXT) AS s
    FROM expand
)
SELECT
    sum(n)
FROM numbers
WHERE
    LENGTH(s) > 1
    AND instr(substr(s || s, 2, LENGTH(s) * 2 - 2), s) > 0;