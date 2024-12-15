Dir.chdir(File.dirname(__FILE__))
require '../requires'

def generate_board
  board, $moves = $buffer.split("\n\n")
  # remove newlines from moves
  $moves = $moves.split("\n").join('')
  puts board
  puts '---'
  puts $moves

  $board = {}
  $max_x = 0
  $max_y = 0
  board.split("\n").each_with_index do |row, y|
    row.split('').each_with_index do |cell, x|
      $board[[x, y]] = cell
      if cell == '@'
        $player = [x, y]
      end
      $max_x = x
    end
    $max_y = y
  end
  ap $board
  ap $player
  ap [$max_x, $max_y]
end

def show_board
  $board.each do |pos, cell|
    print cell
    if pos[0] == 9
      puts
    end
  end
end

def move_player_to(offset)
  new_pos = [$player[0] + offset[0], $player[1] + offset[1]]
  move_pos = new_pos
  if $board[new_pos] == '.'
    $board[$player] = '.'
    $board[new_pos] = '@'
    $player = new_pos
  elsif $board[new_pos] == 'O' # moveable block
    while $board[new_pos] == 'O'
      new_pos = [new_pos[0] + offset[0], new_pos[1] + offset[1]]
    end
    if $board[new_pos] == '.'
      $board[$player] = '.'
      $board[move_pos] = '@'
      $board[new_pos] = 'O'
      $player = move_pos
    end
  end
end

def move_player
  $moves.split('').each do |move|
    case move
    when '^'
      move_player_to([0, -1])
    when 'v'
      move_player_to([0, 1])
    when '<'
      move_player_to([-1, 0])
    when '>'
      move_player_to([1, 0])
    else
      puts "Unknown move: #{move}"
    end
  end
end

def calculate_gps
  gps = 0
  $board.each do |pos, cell|
    if cell == 'O'
      gps_add = (100 * pos[1]) + pos[0]
      gps += gps_add
      puts "Block at #{pos}: #{gps_add}"
    end
  end
  puts gps
end

$buffer = File.read('input_final.txt')
generate_board
move_player
calculate_gps
