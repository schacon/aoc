-- turn all 0s into 1s
WITH RECURSIVE turns AS (
  SELECT 0 as id, 'X' as dir, 0 as amount, 100050 as start_value, 100050 as end_value, 0 as zeros

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
      WHEN m.dir = 'L' THEN ABS(((t.end_value - 1 - m.amount) / 100) - ((t.end_value - 1) / 100))
      WHEN m.dir = 'R' THEN ABS(((t.end_value + m.amount) / 100) - ((t.end_value) / 100))
    END AS zeros
    FROM turns t
    JOIN moves m ON m.id = t.id + 1
)

SELECT sum(zeros) from turns;