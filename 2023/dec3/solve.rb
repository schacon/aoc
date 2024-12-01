Dir.chdir(File.dirname(__FILE__))
require '../requires'

total = 0
engine = []
lines = []
File.open('inputf.txt').each do |line|
  line = line.chomp
  ap line

  index = 0
  number_index = -1
  spaces = {}
  line.chars.each do |char|
    if char != '.'
      if char.ord >= 48 && char.ord <= 57
        if spaces[number_index]
          spaces[number_index] << char
        else
          number_index = index
          spaces[number_index] = char
        end
      else
        spaces[index] = 'symbol'
        number_index = -1
      end
    else
      number_index = -1
    end
    index += 1
  end
  engine << spaces
  lines << line
end

def has_symbol(line, offset, size)
  return false if line.nil?
  for i in (offset - 1)..(offset + size)
    #puts "checking #{line}: #{i}: #{line[i]}"
    return true if line[i] == 'symbol'
  end
  false
end

engine.each_with_index do |line, index|
  puts "#{index}: #{lines[index]}"
  ap line
  line.each do |offset, value|
    if value != 'symbol'
      number = value.to_i
      # look for symbol within offset within row, one row up, one row down
      #puts "checking #{number} at #{index}, #{offset}"
      has = false
      has ||= has_symbol(engine[index - 1], offset, value.size)
      has ||= has_symbol(line, offset, value.size)
      has ||= has_symbol(engine[index + 1], offset, value.size)
      if has
        puts "found #{number} at #{index}, #{offset}"
      end
      total += number if has
    end

  end
end

puts total
