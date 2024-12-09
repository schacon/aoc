Dir.chdir(File.dirname(__FILE__))
require '../requires'


def create_db
  $db.execute <<-SQL
    CREATE TABLE IF NOT EXISTS disk (
      id INTEGER PRIMARY KEY,
      file_id INT
    );
  SQL
end

# Query data
#db.execute 'SELECT * FROM numbers' do |row|
#  p row
#end

$db = SQLite3::Database.new 'final2.db'

def read_file_to_db
  puts "reading"
  buffer = File.read('input_final.txt')
  # read two bytes at a time from the buffer
  file_id = 1
  # read one byte from the file

  file_block = true
  buffer.each_char do |char|
    if file_block
      file_blocks = char.to_i
      file_blocks.times do
        $db.execute 'INSERT INTO disk (file_id) VALUES (?)', [file_id]
      end
      file_id += 1
    else
      # second byte
      empty_blocks = char.to_i
      empty_blocks.times do
        $db.execute 'INSERT INTO disk (file_id) VALUES (?)', [0]
      end
    end
    file_block = !file_block
  end
end

# move last file blocks to the first empty block
def pack_disk
  first_empty_id = 0
  last_full_id = 1
  while first_empty_id < last_full_id
    last_full_block = $db.execute('SELECT id, file_id FROM disk WHERE file_id > 0 ORDER BY id DESC limit 1').first
    first_empty_block = $db.execute('SELECT id, file_id FROM disk WHERE file_id = 0 ORDER BY id ASC limit 1').first
    first_empty_id = first_empty_block[0]
    last_full_id = last_full_block[0]
    if first_empty_id < last_full_id
      $db.execute 'UPDATE disk SET file_id = ? WHERE id = ?', [last_full_block[1], first_empty_id]
      $db.execute 'UPDATE disk SET file_id = 0 WHERE id = ?', [last_full_id]
    end
  end
end

def find_spaces
  openings = "WITH blanks AS (
      SELECT
          id,
          file_id,
          ROW_NUMBER() OVER (ORDER BY id) - id AS grp
      FROM disk
      WHERE file_id = 0
  )
  SELECT
      MIN(id) AS start_id,
      COUNT(*) AS blank_length
  FROM blanks
  GROUP BY grp
  ORDER BY start_id;"
  spaces = []
  $db.execute(openings) do |row|
    spaces << [row[0], row[1]]
  end
  spaces
end

def pack_disk_full
  spaces = find_spaces

  file_id = $db.execute('SELECT MAX(file_id) FROM disk').first.first
  file_id.downto(1) do |file_id|
    data = $db.execute('SELECT MIN(id), COUNT(*) FROM disk where file_id = ?', [file_id]).first
    current_block = data[0]
    file_len = data[1]

    # find a spot
    0.upto(spaces.size - 1) do |index|
      start, len = spaces[index]
      if len >= file_len && start < current_block
        #puts "moving #{file_id} to #{start} #{file_len} -> (#{len})"
        $db.execute 'UPDATE disk SET file_id = 0 WHERE file_id= ?', [file_id] # wipe the old location
        $db.execute 'UPDATE disk SET file_id = ? WHERE id >= ? AND id < ?', [file_id, start, start + file_len] # move the file
        if len > file_len
          spaces[index][0] += file_len
          spaces[index][1] -= file_len
        else
          spaces.delete_at(index)
        end
        break
      end
      index += 1
    end
    puts file_id if file_id % 10 == 0
  end

end

def calculate_checksum
  $db.execute 'SELECT SUM((id - 1) * (file_id - 1)) FROM disk where file_id > 0'
end

def read_db
  puts 'reading'
  checksum = 0
  $db.execute 'SELECT id, file_id FROM disk' do |row|
    pos = row[0] - 1
    id_num = row[1] - 1
    if row[1] > 0
      checksum += pos * id_num
      puts "#{pos}:#{id_num} - #{checksum}"
    end
  end
  checksum
end


#create_db
#read_file_to_db
#puts read_db
#puts "packing"
#pack_disk
pack_disk_full
#puts read_db
puts calculate_checksum
