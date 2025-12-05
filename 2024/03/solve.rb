Dir.chdir(File.dirname(__FILE__))
require '../requires'

puts buffer = File.read('input.txt')
regex = /mul\(\d{1,3},\d{1,3}\)/

total = 0
buffer.scan(regex) do |match|
  puts match
  match.gsub!('mul(', '')
  match.gsub!(')', '')
  a, b = match.split(',')
  puts a, b
  total += (a.to_i * b.to_i)
end
puts total
