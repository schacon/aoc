Dir.chdir(File.dirname(__FILE__))
require '../requires'

side_a = []
side_b = {}
File.open('input_final.txt').each do |line|
  one, two = line.split(" ")
  side_a << one.to_i
  side_b[two.to_i] ||= 0
  side_b[two.to_i] += 1
end

total = 0
side_a.each do |a|
  if !side_b[a].nil?
    total += a * side_b[a]
  end
end

puts total
