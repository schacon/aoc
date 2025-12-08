DROP TABLE IF EXISTS boxes;

CREATE TABLE boxes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    x  INTEGER,
    y  INTEGER,
    z  INTEGER
);

-- Temporary 3-column table for import
DROP TABLE IF EXISTS boxes_import;
CREATE TABLE boxes_import (x INTEGER, y INTEGER, z INTEGER);

.mode csv
.separator ","
.import input_final.txt boxes_import

-- Move into real table
INSERT INTO boxes (x, y, z)
SELECT x, y, z FROM boxes_import;

DROP TABLE boxes_import;