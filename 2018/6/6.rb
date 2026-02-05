require './testing'

class Array
  def x
    self.first
  end

  def y
    self.last
  end
end

def parse(filename)
  File.readlines(filename).map { |l| l.split(',').map(&:to_i) }
end

# https://algs4.cs.princeton.edu/91primitives/
def orientation(a, b, c)
  det = (b.x - a.x) * (c.y - a.y) - (c.x - a.x) * (b.y - a.y)

  if det > 0
    :counterclockwise
  elsif det < 0
    :clockwise
  else
    :colinear
  end
end

def giftwrap(coords)
  leftmost = coords.min_by(&:x)
  current = leftmost
  hull = []

  loop do
    relatively_rightmost = current == coords.first ? coords.last : coords.first

    coords.each do |candidate|
      if orientation(current, relatively_rightmost, candidate) == :counterclockwise
        relatively_rightmost = candidate
      end
    end

    hull << current
    current = relatively_rightmost

    break if current == leftmost
  end

  hull
end

def manhattan_distance(a, b)
  (a.x - b.x).abs + (a.y - b.y).abs
end

BLANK = '.'

def index_to_chr(i)
  (i + 'A'.ord).chr
end

def part_1(filename='input')
  coords = parse(filename)
  hull = giftwrap(coords)
  hull_xs = hull.map(&:x)
  hull_ys = hull.map(&:y)

  top_left = [hull_xs.min, hull_ys.min]
  bottom_right = [hull_xs.max, hull_ys.max]

  width = bottom_right.x - top_left.x
  height = bottom_right.y - top_left.y

  # can't use [Array.new(width)] * height because it will dupe the reference
  grid = Array.new(height) { Array.new(width) }

  grid.each_with_index do |row, y|
    row.length.times do |x|
      min_dist = Float::INFINITY
      min_i = []

      coords.each_with_index do |c, i|
        dist = manhattan_distance(c, [x + top_left.x, y + top_left.y])

        if dist < min_dist
          min_dist = dist
          min_i = [i]
        elsif dist == min_dist
          min_i << i
        end
      end

      if min_i.length == 1
        row[x] = min_i.first
      end
    end
  end

  puts display_grid(grid)

  borders = Set.new
  borders += Set.new(grid.first.compact.map {|i| coords[i]})
  borders += Set.new(grid.last.compact.map {|i| coords[i]})

  height.times do |y|
    borders.add(coords[grid[y][0]]) unless grid[y][0].nil?
    borders.add(coords[grid[y][width - 1]]) unless grid[y][width - 1].nil?
  end

  index, count = grid.flatten.tally.max_by { |k, v| k && !borders.include?(coords[k]) ? v : 0 }
  [index_to_chr(index), count]
end

def display_grid(grid)
  grid.map do |row|
    row.map {|i| i.nil? ? BLANK : index_to_chr(i)}.join
  end.join("\n")
end

if ARGV.include?('--test')
  Testing.expect(parse('test'), [[1, 1], [1, 6], [8, 3], [3, 4], [5, 5], [8, 9]])
  Testing.expect(Set.new(giftwrap(parse('test'))), Set.new([[1, 1], [1, 6], [8, 3], [8, 9]]))
  Testing.expect(part_1('test').last, 17)
  Testing.summary
end

p part_1
