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
    CREATE TABLE IF NOT EXISTS edges (
      id INTEGER PRIMARY KEY,
      node_id INT,
      node_to_id INT,
      direction INT
    );
  SQL
end

def read_nodes(buffer)
  mapx = buffer.split("\n").map { |row| row.split('') }
  id = 1
  ids = {}
  cells = {}
  mapx.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      ids[[x, y]] = id
      $db.execute 'INSERT INTO nodes (id, value) VALUES (?, ?)', [id, cell]
      cells[id] = cell
      id += 1
    end
  end

  mapx.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      # find up, down, left, right
      id = ids[[x, y]]
      next if cells[id] == '#'
      if y > 0
        up = ids[[x, y - 1]]
        if cells[up] != '#'
          $db.execute 'INSERT INTO edges (node_id, node_to_id, direction) VALUES (?, ?, ?)', [id, up, -1]
        end
      end
      if y < mapx.length - 1
        down = ids[[x, y + 1]]
        if cells[down] != '#'
          $db.execute 'INSERT INTO edges (node_id, node_to_id, direction) VALUES (?, ?, ?)', [id, down, 1]
        end
      end
      if x > 0
        left = ids[[x - 1, y]]
        if cells[left] != '#'
          $db.execute 'INSERT INTO edges (node_id, node_to_id, direction) VALUES (?, ?, ?)', [id, left, 2]
        end
      end
      if x < row.length - 1
        right = ids[[x + 1, y]]
        if cells[right] != '#'
          $db.execute 'INSERT INTO edges (node_id, node_to_id, direction) VALUES (?, ?, ?)', [id, right, -2]
        end
      end
    end
  end
end

name = "input_final"
$db = SQLite3::Database.new "#{name}.db"
puts buffer = File.read("#{name}.txt")

create_db
read_nodes(buffer)
