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
      elsif char == '*'
        spaces[index] = 'gear'
        number_index = -1
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

def find_numbers(line, offset)
  return [] if line.nil?
  numbers = []
  line.each do |num_offset, value|
    if value != 'symbol' && value != 'gear'
      if (offset >= (num_offset - 1)) && (offset <= (num_offset + value.size))
        numbers << value.to_i
      end
    end
  end
  numbers
end

engine.each_with_index do |line, index|
  puts "#{index}: #{lines[index]}"
  ap line
  line.each do |offset, value|
    if value == 'gear'
      # look for numbers within offset within row, one row up, one row down
      #puts "checking #{number} at #{index}, #{offset}"
      numbers = []
      numbers << find_numbers(engine[index - 1], offset)
      numbers << find_numbers(engine[index], offset)
      numbers << find_numbers(engine[index + 1], offset)
      numbers.flatten!

      puts "found gear"
      ap numbers

      if numbers.size == 2
        puts "found #{numbers} at #{index}, #{offset}"
        total += numbers.reduce(:*)
      end
    end

  end
end

puts total
