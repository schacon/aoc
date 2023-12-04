Dir.chdir(File.dirname(__FILE__))
require '../requires'

total = 0
File.open('inputf.txt').each do |line|
  line = line.chomp
  game, draws = line.split(":", 2)
  _, id = game.split(" ")

  mins = {
    'red' => 0,
    'green' => 0,
    'blue' => 0
  }

  puts id
  draws.split(";").each do |draw|
    cubes = draw.split(", ")
    cubes.each do |cube|
      cube.chomp!
      number, color = cube.split(" ")
      mins[color] = number.to_i if number.to_i > mins[color]
    end
  end

  power = mins.values.reduce(:*) # power of all mins
  total += power
end

puts total
