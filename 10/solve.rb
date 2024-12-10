Dir.chdir(File.dirname(__FILE__))
require '../requires'


def create_db
  $db.execute <<-SQL
    CREATE TABLE IF NOT EXISTS nodes (
      id INTEGER PRIMARY KEY,
      value INT
    );
  SQL
  $db.execute <<-SQL
    CREATE TABLE IF NOT EXISTS paths (
      id INTEGER PRIMARY KEY,
      node_id INT,
      node_to_id INT
    );
  SQL
end

def read_nodes(buffer)
  mapx = buffer.split("\n").map { |row| row.split('') }
  id = 1
  ids = {}
  mapx.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      ids[[x, y]] = id
      $db.execute 'INSERT INTO nodes (id, value) VALUES (?, ?)', [id, cell]
      id += 1
    end
  end

  mapx.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      # find up, down, left, right
      id = ids[[x, y]]
      if y > 0
        up = ids[[x, y - 1]]
        $db.execute 'INSERT INTO paths (node_id, node_to_id) VALUES (?, ?)', [id, up]
      end
      if y < mapx.length - 1
        down = ids[[x, y + 1]]
        $db.execute 'INSERT INTO paths (node_id, node_to_id) VALUES (?, ?)', [id, down]
      end
      if x > 0
        left = ids[[x - 1, y]]
        $db.execute 'INSERT INTO paths (node_id, node_to_id) VALUES (?, ?)', [id, left]
      end
      if x < row.length - 1
        right = ids[[x + 1, y]]
        $db.execute 'INSERT INTO paths (node_id, node_to_id) VALUES (?, ?)', [id, right]
      end
    end
  end
end

def find_paths
    e = $db.execute <<-SQL
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
  SQL
  e.first.first
end

$db = SQLite3::Database.new 'input_final.db'
puts buffer = File.read('input_final.txt')

#create_db
#read_nodes(buffer)
puts find_paths
