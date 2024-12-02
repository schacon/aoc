Dir.chdir(File.dirname(__FILE__))
require '../requires'

def check_safe(levels)
  levels = levels.split(" ").map(&:to_i)

  # check trend
  first_level = levels.shift
  last_level = levels.shift

  if first_level > last_level
    trend = :down
  elsif first_level < last_level
    trend = :up
  else
    return 0 # unsafe
  end

  # remaining levels all need to be trend
  levels.each do |level|
    if (trend == :down) && ((last_level <= level) || ((last_level - level) > 3))
      puts "X down: #{last_level} #{level}"
      return 0 # unsafe
    end
    if (trend == :up) && ((last_level >= level) || ((level - last_level) > 3))
      puts "X up: #{last_level} #{level}"
      return 0 # unsafe
    end
    last_level = level
  end
  return 1 # safe
end

safe = 0
total = 0
File.open('input_final.txt').each do |line|
  puts line
  safe += check_safe(line)
  total += 1
end
puts safe
puts total
