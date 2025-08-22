def read_input(name='input')
  file = File.open(name)
  file.read.lines
end

class Node < Struct.new(:neighbors, :visited); end

def make_indexed_nodes(input)
  input.map do |line|
    neighbors_str = line.split(' <-> ').last
    Node.new(neighbors_str.split(', ').map(&:to_i), false)
  end
end

def part_1
  input = read_input('input')
  indexed_nodes = make_indexed_nodes(input)
  bfs(0, indexed_nodes).length
end

def bfs(start, indexed_nodes)
  queue = [start]
  reachable = []

  while !queue.empty?
    current_index = queue.shift
    current = indexed_nodes[current_index]

    if !current.visited
      reachable.append(current_index)
      current.visited = true
    end

    current.neighbors.each do |neighbor_index|
      neighbor = indexed_nodes[neighbor_index]

      if !neighbor.visited
        queue.append(neighbor_index)
      end
    end
  end

  reachable
end

def part_2
  input = read_input('input')
  indexed_nodes = make_indexed_nodes(input)
  groups = []
  
  0.upto(indexed_nodes.length - 1) do |i|
    start = indexed_nodes[i]
    if !start.visited
      groups.append(bfs(i, indexed_nodes))
    end
  end

  groups.length
end

puts part_1
puts part_2