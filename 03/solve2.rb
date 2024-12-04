Dir.chdir(File.dirname(__FILE__))
require '../requires'

puts buffer = File.read('input_final.txt')
regex = /do\(\)|don\'t\(\)|mul\(\d{1,3},\d{1,3}\)/

total = 0
count = true
buffer.scan(regex) do |match|
  if match == 'do()'
    count = true
  elsif match == 'don\'t()'
    count = false
  elsif count
    puts "m: #{match}"
    match.gsub!('mul(', '')
    match.gsub!(')', '')
    a, b = match.split(',')
    puts a, b
    total += (a.to_i * b.to_i)
  end
end
puts total
