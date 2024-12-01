Dir.chdir(File.dirname(__FILE__))
require '../requires'

maxes = {
  'red' => 12,
  'green' => 13,
  'blue' => 14
}

total = 0
File.open('inputf.txt').each do |line|
  line = line.chomp
  game, draws = line.split(":", 2)
  _, id = game.split(" ")

  puts id
  possible = true
  draws.split(";").each do |draw|
    cubes = draw.split(", ")
    cubes.each do |cube|
      cube.chomp!
      number, color = cube.split(" ")
      possible = false if number.to_i > maxes[color]
    end
  end

  total += id.to_i if possible
end

puts total
