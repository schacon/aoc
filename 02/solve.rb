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

  if (first_level - last_level).abs > 3
    return 0
  end

  # remaining levels all need to be trend
  levels.each do |level|
    if (trend == :down) && ((last_level <= level) || ((last_level - level) > 3))
      return 0 # unsafe
    end
    if (trend == :up) && ((last_level >= level) || ((level - last_level) > 3))
      return 0 # unsafe
    end
    last_level = level
  end
  return 1 # safe
end

safe = 0
total = 0
File.open('input_final.txt').each do |line|
  safe += check_safe(line)
end
puts "safe: #{safe}"
puts "total: #{total}"
