CREATE TABLE vars (
    iterations INT
);
INSERT INTO vars VALUES (20);

-- turn all 0s into 1s
WITH RECURSIVE all_stones AS (
  SELECT 0 as value, 0 as iteration

  UNION ALL

  SELECT 1 as value, iteration from all_stones where value = 0

    UNION ALL
    -- turn integers with an even number of digits into two integers

    SELECT 
      CAST(SUBSTR(CAST(value AS TEXT), 1, LENGTH(CAST(value AS TEXT)) / 2) AS INT) AS value,
      iteration + 1 as iteration
    FROM all_stones where 
      LENGTH(CAST(value AS TEXT)) % 2 = 0
      AND iteration < (select iterations from vars)

    UNION ALL

    SELECT 
      CAST(SUBSTR(CAST(value AS TEXT), LENGTH(CAST(value AS TEXT)) / 2 + 1, LENGTH(CAST(value AS TEXT))) AS INT) AS value,
      iteration + 1
    FROM all_stones where 
      LENGTH(CAST(value AS TEXT)) % 2 = 0
      AND iteration < (select iterations from vars)

    UNION ALL

    SELECT 
      value * 2024 AS value,
      iteration + 1
    FROM all_stones 
    WHERE (
      value > 0 
      AND LENGTH(CAST(value AS TEXT)) % 2 != 0
      AND iteration < (select iterations from vars)
    )
)

select value, count(*) from all_stones 
group by 1;