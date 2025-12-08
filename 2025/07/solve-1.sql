WITH RECURSIVE
manifold AS (
    SELECT
        row as rowm,
        col as colm,
        '|' as entry
    FROM nodes where entry = 'S'

    UNION ALL

    -- Case 1: below is not '^' -> go straight down
    SELECT
        n.row AS rowm,
        n.col AS colm,
        '|'   AS entry
    FROM manifold m
    JOIN nodes n
      ON n.row = m.rowm + 1
     AND n.col = m.colm
    WHERE n.entry = '.' and m.entry = '|'

  UNION ALL

  -- mark the places we split
  SELECT
        b.row AS rowm,
        b.col AS colm,
        '*'    AS entry
    FROM manifold m
    JOIN nodes b
      ON b.row = m.rowm + 1
     AND b.col = m.colm
     AND b.entry = '^'

    UNION ALL

    -- Case 2a: below is '^' -> go down-left
    SELECT
        nl.row AS rowm,
        nl.col AS colm,
        '|'    AS entry
    FROM manifold m
    JOIN nodes b
      ON b.row = m.rowm + 1
     AND b.col = m.colm
     AND b.entry = '^'
    JOIN nodes nl
      ON nl.row = b.row      -- same row as the '^' below
     AND nl.col = b.col - 1  -- left

    UNION ALL

    -- Case 2b: below is '^' -> go down-right
    SELECT
        nr.row AS rowm,
        nr.col AS colm,
        '|'    AS entry
    FROM manifold m
    JOIN nodes b
      ON b.row = m.rowm + 1
     AND b.col = m.colm
     AND b.entry = '^'
    JOIN nodes nr
      ON nr.row = b.row      -- same row as the '^' below
     AND nr.col = b.col + 1  -- right

)

select count(*) from (
  select rowm, colm, count(*) from manifold where entry = '*'
  group by 1, 2
  )