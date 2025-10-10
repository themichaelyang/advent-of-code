def read_input
  file = File.open('input')
  input = file.read
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

# did you know? p(x) = puts(x.inspect)

DEBUG = false
SLOW = false
require 'pp'

def debug(x, label="")
  if DEBUG
    puts label
    pp x
  end

  if DEBUG && SLOW
    sleep(0.05)
  end

  x
end

def parse_input(input)
  rows = input.split("\n")
  rows.map(&:chars)
end

class Grid2D < Array
  def each_coord(&blk)
    (0...self.height).map do |y|
      (0...self.width).map do |x|
        yield [x, y]
      end
    end
  end

  def width
    self.first.length
  end

  def max_x
    self.width - 1
  end
  
  def height
    self.length
  end

  def max_y
    self.height - 1
  end

  def get(x, y, default=nil)
    if x.between?(0, self.max_x) && y.between?(0, self.max_y)
      self[y][x]
    else
      default
    end
  end

  def set(x, y, v)
    if x.between?(0, self.max_x) && y.between?(0, self.max_y)
      self[y][x] = v
    end
  end
end

# up, right, down, left
DIRECTIONS = [[0, -1], [1, 0], [0, 1], [-1, 0]]

def fill!(grid, start_x, start_y)
  perimeter = 0
  area = 0

  value = grid.get(start_x, start_y)
  stack = [[start_x, start_y]]

  while stack.length > 0 do
    top = stack.pop
    x, y = top.first, top.last

    adjacent = DIRECTIONS.map do |dx, dy|
      [x + dx, y + dy]
    end.uniq

    connected = adjacent.select {|ax, ay| grid.get(ax, ay) == value}
    visited = adjacent.select {|ax, ay| grid.get(ax, ay) == value.downcase}
    
    if grid.get(x, y) == value
      perimeter += 4 - connected.length - visited.length
      area += 1
    end

    stack.concat(connected - visited)

    # need a way to mark a tile as visited by current fill
    grid.set(x, y, value.downcase)
    debug stack, "stack"
  end

  {value: value, perimeter: perimeter, area: area}
end

def part_1
  # parsed = parse_input(sample_input)
  parsed = parse_input(read_input)
  grid = Grid2D.new(parsed)
  debug grid 

  regions = grid.each_coord do |x, y|
    value = grid.get(x, y) 
    # lowercase == visited
    if !value.nil? && value.downcase != value
      debug [x, y]
      # value, perimeter, area = grid.fill!(x, y)
      debug fill!(grid, x, y)
    end
  end.flatten.compact

  debug regions, "regions"

  regions.sum do |r|
    r => {perimeter:, area:}
    perimeter * area
  end
end

puts "part 1: #{part_1}"