class Grid
  attr_accessor :matrix

  def initialize(matrix)
    @matrix = matrix
  end

  def height = @matrix.length
  def width = @matrix.first.length
  def max_x = self.width - 1
  def max_y = self.height - 1

  def within?(coord)
    coord.x.between?(0, self.max_x) && coord.y.between?(0, self.max_y)
  end

  def at(coord)
    if within?(coord)
      @matrix[coord.y][coord.x]
    end
  end

  def set(coord, value)
    if within?(coord)
      @matrix[coord.y][coord.x] = value
    else
      raise Exception("#{coord.to_s} not in grid!")
    end
  end

  def each_coord(&blk)
    return to_enum(:each_coord) unless block_given?

    (0...self.height).flat_map { |y|
      (0...self.width).map { |x| 
        yield Coord.new(x, y)
      }
    }
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
  def rotate_clockwise = Direction.new(-y, x) # (-y, x) instead of (y, -x) because south is +y
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
  # squiggly heredoc <<~ ignores leading whitespace
  <<~EOF
    EE
    EX
  EOF
end

def sample_input_1
  <<~EOF
    RRRRIICCFF
    RRRRIICCCF
    VVRRRCCFFF
    VVRCCCJFFF
    VVVVCJJCFE
    VVIVCCJJEE
    VVIIICJJEE
    MIIIIIJJEE
    MIIISIJEEE
    MMMISSJEEE
  EOF
end

def sample_input_2
  <<~EOF
    AAAAAA
    AAABBA
    AAABBA
    ABBAAA
    ABBAAA
    AAAAAA
  EOF
end

def sample_input_3
  <<~EOF
    EEEEE
    EXXXX
    EEEEE
    EXXXX
    EEEEE
  EOF
end

def default_on_visit(type, coord, grid)
  grid.set(coord, type.downcase)
end

def default_check_visit(type, coord, grid)
  grid.at(coord) == type.downcase
end
def fill_region(
  grid, 
  start, 
  check_visit=method(:default_check_visit), 
  on_visit=method(:default_on_visit),
  outline=nil
)
  perimeter = 0
  area = 0

  type = grid.at(start)
  stack = [start]
  all_corners = Set.new

  while stack.length > 0 do
    coord = stack.pop
    adjacent = Direction.clockwise.map {|dir| dir + coord}

    connected = adjacent.select {|c| grid.at(c) == type}
    # visited = adjacent.select {|c| grid.at(c) == type.downcase}
    # elements that are connected but visited
    visited = adjacent.select {|c| check_visit.call(type, c, grid)}
    
    if grid.at(coord) == type
      perimeter += 4 - connected.length - visited.length
      area += 1
    end

    if outline && connected.length != 4
      p coord
      corners = outline.call(coord)
      all_corners.add(corners)
    end

    stack.concat(connected - visited)

    on_visit.call(type, coord, grid)
    # need a way to mark a tile as visited by current fill
    # grid.set(coord, type.downcase)
  end

  {type: type, perimeter: perimeter, area: area, all_corners: all_corners}
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
# 
# I think to get the inner "holes", we need to check for NOT the same type looking clockwise
# (or check counterclockwise).
def outline_clockwise(grid, start, check_visit=nil, on_visit=nil)
  corners = Set.new
  type = grid.at(start)

  direction = Direction.north
  vertex = start
  changed_direction = false

  while !corners.include?(vertex)
    # if !check_visit.nil? && !check_visit&.call(type, vertex, grid)
    #   return nil
    # end

    lefthand, righthand = relative_left_and_right(vertex, direction)
    along_edge = grid.at(righthand) == type && grid.at(lefthand) != type

    if on_visit && !changed_direction
      on_visit.call(type, vertex, grid)
    end

    if along_edge
      if changed_direction
        corners.add(vertex)
        changed_direction = false
      end

      vertex += direction
    else
      # p [vertex, direction.to_s]
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

def part_1
  parsed = parse_input(read_input)
  garden = Grid.new(parsed)  

  regions = garden.each_coord do |coord|
    type = garden.at(coord) 
    visited = type.downcase == type 
    if type && !visited
      fill_region(garden, coord)
    end
  end.compact

  regions.sum do |r|
    # Pattern matching unpacking!
    r => {perimeter:, area:}
    perimeter * area
  end
end

Region = Struct.new(:type, :perimeter, :area, :sides)
MapEntry = Struct.new(:region, :area_visited, :edge_visited) do
  def initialize
    @region = nil
    @area_visited = false
    @edge_visited = false
  end
end

def make_area_check_visit(map, region)
  lambda do |_t, c, _g|
    map.within?(c) && map.at(c).area_visited && map.at(c)&.region == region 
  end
end

def make_on_area_visit(map, region)
  lambda do |_t, c, _g| 
    map.at(c).area_visited = true 
    map.at(c).region = region
  end
end

def make_edge_check_visit(map, region)
  lambda do |_t, c, _g|
    map.within?(c) && map.at(c).edge_visited && map.at(c)&.region == region 
  end
end

def make_on_edge_visit(map, region)
  lambda do |_t, c, _g| 
    map.at(c).edge_visited = true 
    # map.at(c).region ||= region
  end
end

def part_2
  parsed = parse_input(sample_input_2)
  garden = Grid.new(parsed)

  # NOTE! Don't do: `[nil] * garden.width] * garden.height` or it reuses
  # the reference for the first row everywhere...
  map = Grid.new(Array.new(garden.height + 1) { Array.new(garden.width + 1) { MapEntry.new }})

  regions = garden.each_coord do |coord|
    type = garden.at(coord) 
    entry = map.at(coord)
    visited = entry.area_visited

    # p [coord]

    if !visited
      region = Region.new(type)

      outline = lambda do |c|
        outline_clockwise(
          garden,
          coord,
          make_edge_check_visit(map, region),
          make_on_edge_visit(map, region)
        ).to_a
      end

      region_info = fill_region(
        garden,
        coord, 
        make_area_check_visit(map, region),
        make_on_area_visit(map, region),
        outline
      )

      region.area = region_info[:area]
      region.perimeter = region_info[:perimeter]
      p region_info[:all_corners]

      # region.sides = corners.length
      # puts plot_corners(garden, corners)
      region
    end
  end.compact

  regions.uniq
  # regions.sum {|r| r[:sides].count * r[:area]}
end

# p part_1
# p part_2
p part_2