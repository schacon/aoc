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
),
distances AS (
  -- for each robot, find the distace to the closest robot
  SELECT
    rm.id,
    rm.seconds,
    MIN(ABS(rm.x - rm2.x) + ABS(rm.y - rm2.y)) AS distance
  FROM robot_moves rm
  CROSS JOIN robot_moves AS rm2
  WHERE rm.id != rm2.id
  and rm.seconds = rm2.seconds
  GROUP BY rm.id, rm.seconds
  ORDER BY rm.id
)

select
  seconds,
  SUM(distance) as total_distance
from distances
group by seconds
order by seconds;

