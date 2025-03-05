WITH RECURSIVE paths AS (
  SELECT
      e.node_to_id AS node_id,
      n.value AS node_value,
      ',' || e.node_to_id || ',' AS path,
      ',' || e.direction || ',' AS path_dir,
      1 as cost,
      2 as direction,
      start_nodes.id AS start_node
  FROM edges e
  JOIN nodes n ON e.node_to_id = n.id
  JOIN (SELECT id FROM nodes where value = 'S') AS start_nodes
    ON e.node_id = start_nodes.id

  UNION ALL

  SELECT
      e.node_to_id AS node_id,
      n.value AS node_value,
      r.path || e.node_to_id || ',' AS path,
      r.path_dir || e.direction || ',' AS path_dir,
      -- if the edge direction is the same, the cost is 1, otherwise it's 1000
      CASE
          WHEN e.direction = r.direction THEN r.cost + 1
          WHEN e.direction = -r.direction THEN r.cost + 2001
          ELSE r.cost + 1001
      END AS cost,
      e.direction AS direction,
      r.start_node
  FROM edges e
  JOIN nodes n ON e.node_to_id = n.id
  JOIN paths r
    ON e.node_id = r.node_id
    AND INSTR(r.path, ',' || e.node_to_id || ',') = 0
)

select MIN(cost) from paths where node_value = 'E' 
and start_node = (SELECT id FROM nodes where value = 'S')
