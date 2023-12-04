Dir.chdir(File.dirname(__FILE__))
require '../requires'

total = 0
lines = []
copies = []
line_no = 0

File.open('inputf.txt').each do |line|
  line_no += 1
  copies[line_no] ||= 0
  copies[line_no] += 1
  ap line = line.chomp
  card, numbers = line.split(':')
  _, card_no = card.split(' ')
  winning, ours = numbers.split('|')
  winning = winning.split(' ').map { |n| n.to_i}.uniq
  ours = ours.split(' ').map { |n| n.to_i}.uniq
  ours_winning = winning & ours
  if ours_winning.size > 0
    1.upto(ours_winning.size) do |i|
      copies[line_no + i] ||= 0
      copies[line_no + i] += copies[line_no]
    end
  end
end
ap copies
ap total = copies.compact.inject(:+)
