-- Table to hold pairwise distances
DROP TABLE IF EXISTS box_distances;
CREATE TABLE box_distances (
    box1_id   INTEGER NOT NULL,
    box2_id   INTEGER NOT NULL,
    distance  REAL    NOT NULL,
    PRIMARY KEY (box1_id, box2_id)
);

INSERT INTO box_distances (box1_id, box2_id, distance)
SELECT
    b1.id AS box1_id,
    b2.id AS box2_id,
    (b1.x - b2.x) * (b1.x - b2.x) +
    (b1.y - b2.y) * (b1.y - b2.y) +
    (b1.z - b2.z) * (b1.z - b2.z) AS distance
FROM boxes b1
JOIN boxes b2
  ON b1.id < b2.id;   -- ensures each pair only once, no self-pairs

DROP TABLE IF EXISTS top_circuits;
CREATE TABLE top_circuits (
    circuit_id   INTEGER NOT NULL,
    node_count INTEGER NOT NULL,
    PRIMARY KEY (circuit_id)
);

INSERT INTO top_circuits (circuit_id, node_count) 
WITH top_edges AS (
    SELECT box1_id, box2_id
    FROM box_distances
    ORDER BY distance ASC
    LIMIT 1000
),
nodes AS (
    SELECT box1_id AS node_id FROM top_edges
    UNION
    SELECT box2_id FROM top_edges
),
components(node_id, root) AS (
    SELECT node_id, node_id AS root
    FROM nodes

    UNION

    SELECT
        CASE
            WHEN e.box1_id = c.node_id THEN e.box2_id
            ELSE e.box1_id
        END AS node_id,
        c.root
    FROM components c
    JOIN top_edges e
      ON e.box1_id = c.node_id
      OR e.box2_id = c.node_id
),
final_roots AS (
    SELECT node_id, MIN(root) AS component_root
    FROM components
    GROUP BY node_id
),
circuits AS (
    SELECT
        component_root AS circuit_id,
        COUNT(*) AS node_count,
        GROUP_CONCAT(node_id, ',') AS nodes_in_circuit
    FROM final_roots
    GROUP BY component_root
)
SELECT
    circuit_id, node_count
FROM circuits limit 3;

WITH RECURSIVE
nums AS (
    SELECT node_count AS x, row_number() OVER () AS rn FROM top_circuits
),
prod(rn, val) AS (
    SELECT rn, x FROM nums WHERE rn = 1
    UNION ALL
    SELECT nums.rn, prod.val * nums.x
    FROM prod
    JOIN nums ON nums.rn = prod.rn + 1
)
SELECT val AS product
FROM prod
ORDER BY rn DESC
LIMIT 1;
