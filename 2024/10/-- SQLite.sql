-- SQLite
WITH RECURSIVE reach_nodes AS (
        SELECT
            e.node_to_id AS node_id,
            n.value AS node_value,
            ',' || e.node_to_id || ',' AS path,
            1 as depth,
            start_nodes.id AS start_node
        FROM paths e
        JOIN nodes n ON e.node_to_id = n.id
        JOIN (SELECT id FROM nodes where value = 0) AS start_nodes
          ON e.node_id = start_nodes.id

        UNION ALL

        SELECT
            e.node_to_id AS node_id,
            n.value AS node_value,
            r.path || e.node_to_id || ',' AS path,
            r.depth + 1 as depth,
            r.start_node
        FROM paths e
        JOIN nodes n ON e.node_to_id = n.id
        JOIN reach_nodes r
          ON e.node_id = r.node_id
          AND n.value = r.node_value + 1
          AND INSTR(r.path, ',' || e.node_to_id || ',') = 0
    )

    SELECT count(*) from reach_nodes where node_value = 9 and depth = 9;