require 'set'

def read_input
  file = File.open('input')
  input = file.read
end

def sample_input 
  input = <<EOF
............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............
EOF
end

def at_coord(grid, x, y)
  if x.between?(0, grid.first.length - 1) && y.between?(0, grid.length - 1)
    grid[y][x]
  else
    nil
  end
end

def set_coord(grid, x, y, value)
  if x.between?(0, grid.first.length - 1) && y.between?(0, grid.length - 1)
    grid[y][x] = value
  else
    nil
  end
end

def find_signals(grid)
  signals = []
  (0...grid.length).each do |y|
    (0...grid.first.length).each do |x|
      pt = at_coord(grid, x, y)
      if pt != '.'
        signals.append({
          x: x,
          y: y,
          freq: pt
        }) 
      end
    end
  end

  signals.group_by do |sig|
    sig[:freq]
  end
end

def compute_antinodes(x1, y1, x2, y2)
  x_diff, y_diff = x1 - x2, y1 - y2

  [{x: x1 + x_diff, y: y1 + y_diff}, {x: x2 - x_diff, y: y2 - y_diff}]
end

def parse_input(input)
  input.split("\n").map(&:chars)
end

def plot_on_grid(grid, coords)
  coords.each do |coord|
    set_coord(grid, coord[:x], coord[:y], "#")
  end
end

def part_1
  # input = sample_input
  input = read_input
  grid = parse_input(input)
  signals_by_freq = find_signals(grid)

  antinodes = signals_by_freq.flat_map do |freq, all_with_freq|
    all_with_freq.combination(2).flat_map do |combo| 
      p1 = combo[0]
      p2 = combo[1]

      compute_antinodes(p1[:x], p1[:y], p2[:x], p2[:y])
    end
  end.to_set

  antinodes_on_map = antinodes.select do |an|
    an[:x].between?(0, grid.first.length - 1) && an[:y].between?(0, grid.length - 1)
  end

  # plot_on_grid(grid, antinodes)
  # print_grid(grid)

  antinodes_on_map.length
end

def print_grid(grid)
  puts grid.map(&:join).join("\n")
end

def compute_any_position_antinode(grid, x1, y1, x2, y2)
  x_diff, y_diff = x1 - x2, y1 - y2

  ax, ay = x1 + x_diff, y1 + y_diff
  nodes = []
  while ax.between?(0, grid.first.length - 1) && ay.between?(0, grid.length - 1) do
    nodes.append({x: ax, y: ay})
    ax += x_diff
    ay += y_diff
  end
  
  # any pos antinodes also appear at the nodes themselves
  ax, ay = x1, y1
  while ax.between?(0, grid.first.length - 1) && ay.between?(0, grid.length - 1) do
    nodes.append({x: ax, y: ay})
    ax -= x_diff
    ay -= y_diff
  end
 
  nodes
end

def part_2
  # input = sample_input
  input = read_input
  grid = parse_input(input)
  signals_by_freq = find_signals(grid)

  antinodes = signals_by_freq.flat_map do |freq, all_with_freq|
    all_with_freq.combination(2).flat_map do |combo| 
      p1 = combo[0]
      p2 = combo[1]

      compute_any_position_antinode(grid, p1[:x], p1[:y], p2[:x], p2[:y])
    end
  end.to_set

  antinodes_on_map = antinodes.select do |an|
    an[:x].between?(0, grid.first.length - 1) && an[:y].between?(0, grid.length - 1)
  end

  plot_on_grid(grid, antinodes_on_map)
  print_grid(grid)

  antinodes_on_map.length
end

# puts "part 1:\n#{part_1}"
puts "part 2:\n#{part_2}"