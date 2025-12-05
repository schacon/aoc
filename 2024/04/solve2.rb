Dir.chdir(File.dirname(__FILE__))
require '../requires'

buffer = File.read('input_final.txt')

buffer_d = buffer.split("\n").map { |row| row.split('') }
rows = buffer_d.size
cols = buffer_d[0].size

pattern = [
  [0, 0],
  [0, 2],
  [1, 1],
  [2, 0],
  [2, 2],
]
match = /MSAMS|SMASM|MMASS|SSAMM/
matches = 0
rows.times do |i|
  cols.times do |j|
    x_pattern = []
    pattern.each do |x, y|
      x_pattern << buffer_d[i + x][j + y] rescue nil
    end

    if x_pattern.join('') =~ match
      puts x_pattern.join('')
      matches += 1
    end
  end
end

puts matches
