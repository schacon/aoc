-- SQLite
-- id INTEGER PRIMARY KEY,
-- x INT,
-- y INT,
-- velocity_x INT,
-- velocity_y INT

WITH RECURSIVE robot_moves AS (
  SELECT
      id, x, y, velocity_x, velocity_y, 
      0 AS seconds
  FROM robots

  UNION ALL

  SELECT
      id, 
      (x + velocity_x + 101) % 101,
      (y + velocity_y + 103) % 103,
      velocity_x, 
      velocity_y,
      seconds + 1
  FROM robot_moves
  WHERE seconds < 100
)

-- count robots in each quadrant

SELECT
  SUM(CASE WHEN x < 101/2 AND y < 103/2 THEN 1 ELSE 0 END) 
  * 
  SUM(CASE WHEN x > 101/2 AND y < 103/2 THEN 1 ELSE 0 END)
  *
  SUM(CASE WHEN x < 101/2 AND y > 103/2 THEN 1 ELSE 0 END)
  * 
  SUM(CASE WHEN x > 101/2 AND y > 103/2 THEN 1 ELSE 0 END) AS total
FROM robot_moves
WHERE seconds = 100;
