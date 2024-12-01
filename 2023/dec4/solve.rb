Dir.chdir(File.dirname(__FILE__))
require '../requires'

total = 0
lines = []

File.open('inputf.txt').each do |line|
  ap line = line.chomp
  card, numbers = line.split(':')
  _, card_no = card.split(' ')
  winning, ours = numbers.split('|')
  winning = winning.split(' ').map { |n| n.to_i}.uniq
  ours = ours.split(' ').map { |n| n.to_i}.uniq
  ours_winning = winning & ours
  if ours_winning.size > 0
    ap ours_winning
    ap thist = 2.pow(ours_winning.size - 1)
    total += thist
  end
end

ap total
