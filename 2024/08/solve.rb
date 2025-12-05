Dir.chdir(File.dirname(__FILE__))
require '../requires'

def find_nodes(map)
  nodes = {}
  map.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      if cell != '.'
        nodes[cell] ||= []
        nodes[cell] << [x, y]
      end
    end
  end
  nodes
end

def add_node(map, antis, x, y)
  if map[x]&.dig(y)
    antis[x] ||= {}
    antis[x][y] = '#'
  end
  antis
end

def find_antinodes(map, nodes)
  # every group of two
  antis = {}
  nodes.each do |node, coords|
    coords.combination(2).each do |coord1, coord2|
      # find antinodes
      if (coord1[1] < coord2[1])
        anti0 = coord1[0] + (coord1[0] - coord2[0])
        anti1 = coord1[1] - (coord2[1] - coord1[1])
        antis = add_node(map, antis, anti0, anti1)

        anti0 = coord2[0] - (coord1[0] - coord2[0])
        anti1 = coord2[1] + (coord2[1] - coord1[1])
        antis = add_node(map, antis, anti0, anti1)
      else
        puts "#{node} #{coord1[0]},#{coord1[1]} - #{coord2[0]},#{coord2[1]} => #{anti0},#{anti1}"
      end
    end
  end
  antis
end

def printm(map, antis)
  total = 0
  map.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      if cell == '.'
        if an = antis[x]&.dig(y)
          print an
          total += 1
        else
          print cell
        end
      else
        if an = antis[x]&.dig(y)
          print "@"
          total += 1
        else
          print cell
        end
      end
    end
    puts
  end
  total
end

buffer = File.read('input_final.txt')
mapx = buffer.split("\n").map { |row| row.split('') }
nodes = find_nodes(mapx)

anti_nodes = find_antinodes(mapx, nodes)
ap count = printm(mapx, anti_nodes)

puts count
