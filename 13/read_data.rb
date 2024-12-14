
Dir.chdir(File.dirname(__FILE__))
require '../requires'

def create_db
  $db.execute <<-SQL
    CREATE TABLE IF NOT EXISTS robots (
      id INTEGER PRIMARY KEY,
      x INT,
      y INT,
      velocity_x INT,
      velocity_y INT
    );
  SQL
end

def read_nodes(buffer)
  id = 1
  buffer.each_line do |line|
    # p=10,3 v=-1,2
    line.match(/p=(?<p_x>\d+),(?<p_y>\d+) v=(?<v_x>-?\d+),(?<v_y>-?\d+)/) do |m|
      puts "#{id} #{m[:p_x]} #{m[:p_y]} #{m[:v_x]} #{m[:v_y]}"
      $db.execute("INSERT INTO robots (x, y, velocity_x, velocity_y) VALUES (#{m[:p_x]}, #{m[:p_y]}, #{m[:v_x]}, #{m[:v_y]})")
      id += 1
    end
  end
end

name = "input_final"
$db = SQLite3::Database.new "#{name}.db"
buffer = File.read("#{name}.txt")

create_db
read_nodes(buffer)
#puts find_paths
