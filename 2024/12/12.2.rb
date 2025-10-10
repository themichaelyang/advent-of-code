class Grid
  def initialize(matrix)
    @matrix = matrix
  end

  def height = @matrix.length
  def width = @matrix.first.length
  def max_x = self.width - 1
  def max_y = self.height - 1

  def at(coord)
    if within?(coord)
      @matrix[coord.y][coord.x]
    end
  end

  def within?(coord)
    coord.x.between?(0, self.max_x) && coord.y.between?(0, self.max_y)
  end
end

class Coord < Struct.new(:x, :y)
  def initialize(x, y) = super(x, y)
  def to_a = [x, y]
  def +(other) = Coord.new(other.x + x, other.y + y)
  def to_s = "(#{x}, #{y})"
  def inspect = to_s
end

class Direction < Coord
  @@directions = {
    north: Direction.new(0, -1),
    east: Direction.new(1, 0),
    south: Direction.new(0, 1),
    west: Direction.new(-1, 0)
  }

  def self.north = @@directions[:north]
  def self.east = @@directions[:east]
  def self.south = @@directions[:south]
  def self.west = @@directions[:west]

  def self.clockwise = [north, east, south, west]
  def rotate_clockwise = Direction.new(y, -x)
  def to_s = "<#{@@directions.key(self)&.to_s}>" || super
end

def read_input
  file = File.open('input')
  input = file.read
end

def parse_input(input)
  rows = input.split("\n")
  rows.map(&:chars)
end

def sample_input 
#   input = <<EOF
# AAAA
# BBCD
# BBCC
# EEEC
# EOF
input = <<EOF
EE
EX
EOF
end

# For a given "vertex space" coordinate and direction,
# get the block coordinates of the left and right blocks you are facing.
#
# North     East      South     West
# o--o--o   o--o--o   o--o--o   o--o--o
# | L| R|   |  | L|   |  |  |   | R|  |
# o- ^ -o   o- > -o   o- v -o   o- < -o
# |  |  |   |  | R|   | R| L|   | L|  |
# o--o--o   o--o--o   o--o--o   o--o--o
#
# As a convention, vertex coordinates correspond to the top left vertex
# of a grid block.
def relative_left_and_right(vertex, facing)
  dl, dr = case facing
  when Direction.north
    [Coord.new(-1, -1), Coord.new(0, -1)]
  when Direction.east
    [Coord.new(0, -1), Coord.new(0, 0)]
  when Direction.south
    [Coord.new(0, 0), Coord.new(-1, 0)]
  when Direction.west
    [Coord.new(-1, 0), Coord.new(-1, -1)]
  else
    raise "Not a valid direction #{facing.to_s}"
  end

  [vertex + dl, vertex + dr]
end

# Follow clockwise around the border until we get back to a corner we've seen.
# Add a corner every time we change direction.
def outline_clockwise(grid, start)
  corners = Set.new()
  type = grid.at(start)

  direction = Direction.north
  vertex = start
  changed_direction = false

  while !corners.include?(vertex)
    lefthand, righthand = relative_left_and_right(vertex, direction)
    along_edge = grid.at(righthand) == type && grid.at(lefthand) != type

    if along_edge 
      if changed_direction
        corners.add(vertex)
        changed_direction = false
      end

      vertex += direction
    else
      direction = direction.rotate_clockwise
      changed_direction = true
    end
  end

  corners
end

def plot_corners(grid, corners)
  lines = []

  (grid.height + 1).times do |y|
    corner_row = (grid.width + 1).times.map do |x|
      if corners.include?(Coord.new(x, y))
        'o--'
      else
        '+--'
      end
    end
    
    lines.append(corner_row.join)

    block_row = (grid.width + 1).times.map do |x|
      " #{grid.at(Coord.new(x, y)) || ' '}"
    end
    lines.append('|' + block_row.join('|'))
  end
  
  lines.join("\n")
end

def part_2
  parsed = parse_input(sample_input)
  grid = Grid.new(parsed)  

  corners = outline_clockwise(grid, Coord.new(0, 0))

  plot_corners(grid, corners)
end

puts part_2