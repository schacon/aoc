Dir.chdir(File.dirname(__FILE__))
require '../requires'

digits = {
  'one' => 1,
  'two' => 2,
  'three' => 3,
  'four' => 4,
  'five' => 5,
  'six' => 6,
  'seven' => 7,
  'eight' => 8,
  'nine' => 9,
}

total = 0
File.open('input2f.txt').each do |orig_line|
  puts '-------'
  puts orig_line
  line = orig_line
  line_no = []

  # find the first digit to replace
  match = 99999
  replace_digit = nil
  replace_word = nil

  line = []
  orig_line.chars.each_with_index do |char, index|
    digits.each do |word, digit|
      if char == word[0]
        if orig_line[index, word.size] == word
          line << digit
        end
      end
    end
    line << char
  end

  puts line.join('')

  line.each do |char|
    if char.to_i > 0
      line_no << char
    end
  end

  line_total = (line_no.first.to_i * 10) + line_no.last.to_i
  total += line_total
end

puts total
