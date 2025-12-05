Dir.chdir(File.dirname(__FILE__))
require '../requires'

def find_all(buffer)
  look_for = /XMAS/
  look_for2 = /SAMX/
  # look forward
  matches = 0
  buffer.scan(look_for) do |match|
    puts "m: #{match}"
    matches += 1
  end
  buffer.scan(look_for2) do |match|
    puts "m: #{match}"
    matches += 1
  end
  matches
end

def get_diagonals(buffer)
  diags = []

  # look diagonal right to left
  # make a 2d array of the buffer
  buffer_d = buffer.split("\n").map { |row| row.split('') }
  # get diagonal from top left to bottom right
  rows = buffer_d.size
  0.upto(rows - 1) do |i|
    diag_buffer = []
    col = 0
    i.downto(0) do |j|
      diag_buffer << buffer_d[j][col]
      col += 1
    end
    diags << diag_buffer.join('')
  end

  diags2 = []
  cols = buffer_d[0].size
  (cols - 1).downto(1) do |i|
    diag_buffer = []
    r = rows - 1
    i.upto(rows - 1) do |j|
      diag_buffer << buffer_d[r][j]
      r -= 1
    end
    diags2 << diag_buffer.join('')
  end
  diags = diags + diags2.reverse
  diags.join("\n")
end

puts buffer = File.read('input_final.txt')

matches = 0
matches += find_all(buffer)

# look vertical
# rearrange buffer so each column is a string
buffer_v = buffer.split("\n").map { |row| row.split('') }
buffer_v = buffer_v.transpose.map { |col| col.join('') }
puts buffer_v = buffer_v.join("\n")

matches += find_all(buffer_v)

puts buffer_d = get_diagonals(buffer)
matches += find_all(buffer_d)

puts buffer_r = buffer.split("\n").map { |row| row.split('').reverse.join('') }.join("\n")
puts buffer_dr = get_diagonals(buffer_r)
matches += find_all(buffer_dr)

puts matches

# look diagonal left to right
