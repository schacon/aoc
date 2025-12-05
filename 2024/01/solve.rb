Dir.chdir(File.dirname(__FILE__))
require '../requires'

side_a = []
side_b = []
File.open('input_final.txt').each do |line|
  one, two = line.split(" ")
  side_a << one
  side_b << two
end

side_a.sort!
side_b.sort!

diff = 0
side_a.each_with_index do |a, i|
  b = side_b[i]
  diff += (b.to_i - a.to_i).abs
end

puts diff
