-- SQLite
-- button_a_x INT,
-- button_a_y INT,
-- button_b_x INT,
-- button_b_y INT,
-- prize_x INT,
-- prize_y INT

-- 3 tokens to push a, 1 token to push b

WITH RECURSIVE game_runs_a AS (
  SELECT
      id, 
      button_a_x, 
      button_a_y,
      button_b_x, 
      button_b_y,
      prize_x,
      prize_y,

      0 as current_cost,
      0 as current_x,
      0 as current_y,

      0 AS pushes_a,
      0 AS pushes_b
  FROM games

  UNION ALL

  SELECT
      id, 
      button_a_x, 
      button_a_y,
      button_b_x, 
      button_b_y,
      prize_x,
      prize_y,

      (pushes_a * 3) + pushes_b as current_cost,
      (pushes_a * button_a_x) + (pushes_b * button_b_x) as current_x,
      (pushes_a * button_a_y) + (pushes_b * button_b_y) as current_y,

      pushes_a + 1,
      pushes_b
  FROM game_runs_a
  WHERE pushes_a < 100
),
game_runs_b AS (
  SELECT 
      id, 
      button_a_x, 
      button_a_y,
      button_b_x, 
      button_b_y,
      prize_x,
      prize_y,

      current_cost,
      current_x,
      current_y,

      pushes_a,
      pushes_b
  FROM games_runs_a

  UNION ALL

  SELECT
      id, 
      button_a_x, 
      button_a_y,
      button_b_x, 
      button_b_y,
      prize_x,
      prize_y,

      (pushes_a * 3) + pushes_b as current_cost,
      (pushes_a * button_a_x) + (pushes_b * button_b_x) as current_x,
      (pushes_a * button_a_y) + (pushes_b * button_b_y) as current_y,

      pushes_a,
      pushes_b + 1
  FROM game_runs_b
  WHERE pushes_b < 100
)

select * from game_runs_b where id = 1 
and current_x = prize_x 
and current_y = prize_y 
order by current_cost;

