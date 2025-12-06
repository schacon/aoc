WITH RECURSIVE
expand AS (
    -- Start each range at start_range
    SELECT
        start_range AS n,
        end_range
    FROM ranges

    UNION ALL

    -- Increment until we reach end_range
    SELECT
        n + 1,
        end_range
    FROM expand
    WHERE n < end_range
)

SELECT SUM(n)
FROM expand
WHERE
    -- Convert to text
    LENGTH(CAST(n AS TEXT)) % 2 = 0  -- must be even length
    AND SUBSTR(CAST(n AS TEXT), 1, LENGTH(CAST(n AS TEXT)) / 2)
        = SUBSTR(CAST(n AS TEXT),
                 LENGTH(CAST(n AS TEXT)) / 2 + 1);