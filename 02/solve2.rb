Dir.chdir(File.dirname(__FILE__))
require '../requires'

def check_safe(levels)
  levels = levels.split(" ").map(&:to_i)

  # check trend
  first_level = levels.shift
  last_level = levels.shift
  unsafe = 0

  if first_level > last_level
    trend = :down
  elsif first_level < last_level
    trend = :up
  else
    unsafe = 1
    first_level = last_level
    last_level = levels.shift
    if first_level > last_level
      trend = :down
    elsif first_level < last_level
      trend = :up
    else
      return 0 # unsafe
    end
    #last_level = first_level # don't advance it
  end

  if (first_level - last_level).abs > 3
    last_level = first_level # don't advance it
    unsafe += 1
    return 0 if unsafe > 1
  end

  # remaining levels all need to be trend
  levels.each do |level|
    if (trend == :down) && ((last_level <= level) || ((last_level - level) > 3))
      unsafe += 1
      return 0 if unsafe > 1
    elsif (trend == :up) && ((last_level >= level) || ((level - last_level) > 3))
      unsafe += 1
      return 0 if unsafe > 1
    else
      last_level = level
    end
  end
  return 1 # safe
end

safe = 0
total = 0
File.open('input_final.txt').each do |line|
  safe_check = check_safe(line)
  puts "#{safe_check} #{line}"
  safe += safe_check
end
puts "safe: #{safe}"
puts "total: #{total}"
