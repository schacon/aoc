WITH RECURSIVE process_values AS (
    -- Base case: Start with initial values
    SELECT 12 AS result, 1 AS iteration
    UNION ALL
    SELECT 15 AS result, 1 AS iteration
    UNION ALL
    SELECT 24 AS result, 1 AS iteration

    UNION ALL

    -- Recursive case: Process each value
    SELECT
        CASE
            -- If even, split into individual digits
            WHEN result % 2 = 0 THEN CAST(SUBSTR(CAST(result AS TEXT), 1, 1) AS INT)
            -- If odd, multiply by 8
            ELSE result * 8
        END AS result,
        iteration + 1 AS iteration
    FROM process_values
    WHERE iteration < 5 -- Limit to 5 iterations to avoid infinite recursion
)
-- Final output: List all results
SELECT iteration, result
FROM process_values
ORDER BY iteration, result;
