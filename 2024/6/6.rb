def read_input
  file = File.open('input')
  input = file.read
end

def sample_input 
  input = <<EOF
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
EOF
end

def parse_input(input)
  grid = input.split("\n").map(&:chars)
end

def find_guard(grid)
  (0...grid.length).each do |y|
    (0...grid.first.length).each do |x|
      if grid[y][x] == '^'
        return [x, y]
      end
    end
  end
  
  return nil
end

def calculate_path(grid)
  width = grid.first.length
  height = grid.length
  guard_x, guard_y = find_guard(grid)

  direction = :up
  rotations = [:up, :right, :down, :left]

  # [x, y]
  direction_to_deltas = {
    up: [0, -1],
    right: [1, 0],
    down: [0, 1],
    left: [-1, 0]
  }

  grid[guard_y][guard_x] = "X"
  while guard_x.between?(0, width - 1) && guard_y.between?(0, height - 1) do
    direction_x, direction_y = direction_to_deltas[direction]

    # mark as visited, with direction
    grid[guard_y][guard_x] = direction.to_s[0].upcase
    new_y = guard_y + direction_y
    new_x = guard_x + direction_x

    # obstacle
    if new_x.between?(0, width - 1) && new_y.between?(0, height - 1) && grid[new_y][new_x] == '#'
      rotation_index = (rotations.index(direction) + 1) % rotations.length
      direction = rotations[rotation_index]
    else
      guard_y = new_y
      guard_x = new_x
    end

    # puts [guard_x, guard_y, grid[guard_y][guard_x], new_x, new_y, grid[new_y][new_x], direction].inspect
    # puts grid.map {|row| row.join}.join("\n")
  end

  grid
end

def part_1
  grid = parse_input(sample_input)
  # grid = parse_input(read_input)
  grid_path = calculate_path(grid)

  grid_path.flatten.count {|c| 'URDL'.include?(c)}
end


def find_loop(grid, guard_x, guard_y, obstacle_x, obstacle_y)
  width = grid.first.length
  height = grid.length
  
  direction = :up
  rotations = [:up, :right, :down, :left]

  # [x, y]
  direction_to_deltas = {
    up: [0, -1],
    right: [1, 0],
    down: [0, 1],
    left: [-1, 0]
  }

  grid[guard_y][guard_x] = "U"

  while guard_x.between?(0, width - 1) && guard_y.between?(0, height - 1) do
    direction_x, direction_y = direction_to_deltas[direction]

    new_y = guard_y + direction_y
    new_x = guard_x + direction_x

    # obstacle
    if (new_x.between?(0, width - 1) && new_y.between?(0, height - 1) && grid[new_y][new_x] == '#') || (new_x == obstacle_x && new_y == obstacle_y)
      rotation_index = (rotations.index(direction) + 1) % rotations.length
      direction = rotations[rotation_index]
    else
      prev = [guard_x, guard_y]
      guard_y = new_y
      guard_x = new_x

      # visited before and going same direction
      if guard_x.between?(0, width - 1) && guard_y.between?(0, height - 1)
        if (grid[guard_y][guard_x] == "U" && direction == :up) \
          || (grid[guard_y][guard_x] == "D" && direction == :down) \
          || (grid[guard_y][guard_x] == "L" && direction == :left) \
          || (grid[guard_y][guard_x] == "R" && direction == :right)
          # puts [obstacle_x, obstacle_y].inspect
          # puts [guard_x, guard_y, grid[guard_y][guard_x], prev, direction].inspect
          # puts [obstacle_x, obstacle_y].inspect
          # puts grid.map {|row| row.join}.join("\n")

          return true
        end

        # mark as visited. we can only mark visited after we are sure of direction
        grid[guard_y][guard_x] = direction.to_s[0].upcase
      end
    end
  end
  return false
end

def part_2
  # grid = parse_input(sample_input)
  grid = parse_input(read_input)
  guard_x, guard_y = find_guard(grid)

  # puts [guard_x, guard_y].inspect

  (0...grid.length).flat_map do |y|
    (0...grid.first.length).flat_map do |x| 
      unless x == guard_x && y == guard_y
        # clone grid
        grid = parse_input(read_input)
        find_loop(grid, guard_x, guard_y, x, y)
      end
    end
  end.count(true)
end

puts "part 1: \n#{part_1}"
# 1753
puts "part 2: #{part_2}"

# 3, 6?