-- turn all 0s into 1s
WITH RECURSIVE turns AS (
  SELECT 0 as id, 'X' as dir, 0 as amount, 50 as start_value, 50 as end_value, 50 as end_value_mod_100

  UNION ALL

  SELECT
    m.id,
    m.dir,
    m.amount,
    t.end_value AS start_value,
    CASE 
      WHEN m.dir = 'L' THEN (t.end_value - m.amount)
      WHEN m.dir = 'R' THEN (t.end_value + m.amount)
    END AS end_value,
    CASE 
      WHEN m.dir = 'L' THEN ABS((t.end_value - m.amount) % 100)
      WHEN m.dir = 'R' THEN ABS((t.end_value + m.amount) % 100)
    END AS end_value_mod_100
    FROM turns t
    JOIN moves m ON m.id = t.id + 1
)

SELECT count(*) from turns where end_value_mod_100 = 0;