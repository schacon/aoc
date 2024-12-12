Dir.chdir(File.dirname(__FILE__))
require '../requires'

$db = SQLite3::Database.new 'nodes.db'

$cache = {}

def find_rocks(value, it)
  $cache[value] ||= {}
  return $cache[value][it] if $cache[value][it]
  e = $db.execute <<-SQL
  WITH RECURSIVE all_stones AS (

  SELECT #{value} as value, 0 as iteration

  UNION ALL

    SELECT 1 as value, iteration + 1 from all_stones where value = 0

    UNION ALL
    -- turn integers with an even number of digits into two integers

    SELECT
      CAST(SUBSTR(CAST(value AS TEXT), 1, LENGTH(CAST(value AS TEXT)) / 2) AS INT) AS value,
      iteration + 1 as iteration
    FROM all_stones where
      LENGTH(CAST(value AS TEXT)) % 2 = 0
      AND iteration < #{it}

    UNION ALL

    SELECT
      CAST(SUBSTR(CAST(value AS TEXT), LENGTH(CAST(value AS TEXT)) / 2 + 1, LENGTH(CAST(value AS TEXT))) AS INT) AS value,
      iteration + 1
    FROM all_stones where
      LENGTH(CAST(value AS TEXT)) % 2 = 0
      AND iteration < #{it}

    UNION ALL

    SELECT
      value * 2024 AS value,
      iteration + 1
    FROM all_stones
    WHERE (
      value > 0
      AND LENGTH(CAST(value AS TEXT)) % 2 != 0
      AND iteration < #{it}
    )
)
  select value, count(*) from all_stones where iteration = #{it} group by value;
  SQL
  $cache[value][it] = e
  return e
end

start = "125 17"
start = "9694820 93 54276 1304 314 664481 0 4"

ap totals = start.split(' ').map(&:to_i).inject({}) { |h, v| h[v] = 1; h }

5.times do
  new_totals = {}
  puts totals.keys.count
  totals.each do |rock, count|
    rocks = find_rocks(rock, 15)
    rocks.each do |row|
      rock_value = row[0].to_i
      rock_count = row[1].to_i

      new_totals[rock_value] ||= 0
      new_totals[rock_value] += rock_count * count
    end
  end
  totals = new_totals
end

ap totals
puts totals.keys.count
puts totals.values.inject(:+)
