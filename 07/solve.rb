Dir.chdir(File.dirname(__FILE__))
require '../requires'

puts buffer = File.read('input_final.txt')

def possible_totals(numbers)
  return [numbers.first] if numbers.length == 1
  first = numbers.shift
  totals = []
  possible_totals(numbers).each do |p_total|
    totals << first + p_total
    totals << first * p_total
  end
  totals
end

def is_ok?(total, numbers)
  possible_totals(numbers).each do |p_total|
    puts "possible total: #{p_total}"
    return true if total == p_total
  end
  false
end

final = 0
buffer.each_line do |line|
  puts line
  total, numbers = line.split(':', 2)
  numbers = numbers.split(' ').map(&:to_i).reverse
  total = total.to_i
  if is_ok?(total, numbers)
    final += total
  end
end

puts final
