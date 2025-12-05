
Dir.chdir(File.dirname(__FILE__))
require '../requires'

def create_db
  $db.execute <<-SQL
    CREATE TABLE IF NOT EXISTS games (
      id INTEGER PRIMARY KEY,
      button_a_x INT,
      button_a_y INT,
      button_b_x INT,
      button_b_y INT,
      prize_x INT,
      prize_y INT
    );
  SQL
end

#Button A: X+94, Y+34
#Button B: X+22, Y+67
#Prize: X=8400, Y=5400
def read_nodes(buffer)
  data = {}
  buffer.each_line do |line|
    if line.start_with?("Button A")
      line.match(/Button A: X\+(\d+), Y\+(\d+)/) do |m|
        data[:button_a_x] = m[1].to_i
        data[:button_a_y] = m[2].to_i
      end
    elsif line.start_with?("Button B")
      line.match(/Button B: X\+(\d+), Y\+(\d+)/) do |m|
        data[:button_b_x] = m[1].to_i
        data[:button_b_y] = m[2].to_i
      end
    elsif line.start_with?("Prize")
      line.match(/Prize: X=(\d+), Y=(\d+)/) do |m|
        data[:prize_x] = m[1].to_i
        data[:prize_y] = m[2].to_i
      end
      $db.execute("INSERT INTO games (button_a_x, button_a_y, button_b_x, button_b_y, prize_x, prize_y) VALUES (#{data[:button_a_x]}, #{data[:button_a_y]}, #{data[:button_b_x]}, #{data[:button_b_y]}, #{data[:prize_x]}, #{data[:prize_y]})")
      ap data
      data = {}
    end
  end
end

name = "input_final"
$db = SQLite3::Database.new "#{name}.db"
buffer = File.read("#{name}.txt")

create_db
read_nodes(buffer)
#puts find_paths
