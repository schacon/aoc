Dir.chdir(File.dirname(__FILE__))
require '../requires'

total = 0
File.open('input_final.txt').each do |line|
  line_no = []
  line.chars.each do |char|
    if char.to_i > 0
      line_no << char
    end
  end
  puts line_total = (line_no.first.to_i * 10) + line_no.last.to_i
  total += line_total
end

puts total
