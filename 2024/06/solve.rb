Dir.chdir(File.dirname(__FILE__))
require '../requires'

puts buffer = File.read('input_final.txt')

def printp(pos)
  pos.each do |row|
    puts row.join('')
  end
end

def find_start(r, row)
  row.each_with_index do |char, i|
    if char == '^'
      $pos = [r, i]
    end
  end
end

def movep(mapx)
  mapx[$pos[0]][$pos[1]] = "X"
  next_char = mapx[$pos[0] + $move[0]][$pos[1] + $move[1]] rescue ''

  if next_char == '#'
    case $move
    when [0, 1]
      $move = [1, 0]
    when [0, -1]
      $move = [-1, 0]
    when [1, 0]
      $move = [0, -1]
    when [-1, 0]
      $move = [0, 1]
    end
    return movep(mapx)
  end

  $pos = [$pos[0] + $move[0], $pos[1] + $move[1]]
  mapx
end

$move = [-1, 0]
$pos = [0, 0]
r = 0
mapx = buffer.split("\n").map { |row| row_x = row.split(''); find_start(r, row_x); r +=1; row_x }

printp(mapx)
while mapx[$pos[0]] && mapx[$pos[0]][$pos[1]] && $pos[0] >= 0 && $pos[1] >= 0
  mapx = movep(mapx)
  #printp(mapx)
end

# count how many 'X' are in the map
printp(mapx)
puts mapx.flatten.count('X')
