Dir.chdir(File.dirname(__FILE__))
require '../requires'

puts buffer = File.read('input_final.txt')

def is_correct_order(pages, befores)
  orders = {}
  pages.each_with_index do |page, index|
    orders[page] = index
  end
  orders.each do |page, index|
    if b4s = befores[page]
      b4s.each do |b4|
        puts "Checking #{page} before #{b4}"
        next if !orders[b4]
        if orders[b4] < index
          puts "Incorrect order: #{page} before #{b4}"
          return false
        end
      end
    end
  end
  return true
end

pages = false
befores = {}
total = 0
buffer.each_line do |line|
  if line == "\n"
    pages = true
  else
    if !pages
      before, after = line.chomp.split("|")
      befores[before] ||= []
      befores[before] << after
    else
      ap pages = line.chomp.split(',')
      if is_correct_order(pages, befores)
        ap middle = pages[pages.size / 2]
        total += middle.to_i
      end
    end
  end
end

puts total
