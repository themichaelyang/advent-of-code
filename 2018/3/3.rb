require '../testing'

class Array
  def x
    self.first
  end

  def y
    self.last
  end
end

def parse(filename)
  File.readlines(filename).map do |line|
    _num, _at, coord_str, size_str = line.split

    width, height = size_str.split('x').map(&:to_i)
    x, y = coord_str.split(',').map(&:to_i)

    { width:, height:, x:, y: }
  end
end

def make_corners(claim)
  [[claim[:x], claim[:y]],
   [claim[:x] + claim[:width] - 1, claim[:y] + claim[:height] - 1]]
end

def within?(coord, top_left, bottom_right)
  coord.x >= top_left.x && coord.x <= bottom_right.x &&
  coord.y >= top_left.y && coord.y <= bottom_right.y
end

def display_grid(grid)
  grid.map do |row|
    row.join
  end.join("\n")
end

# we could use a pixel grid (input size is small enough), but we can also slice it into regions,
# where each x, y is some combination of an x and a y from the regions.
# consider that any overlap's corners must be the x of an existing region and a y of a existing region.
#
# lets do the easy one first:
def part_1_naive(filename='input')
  claims = parse(filename)
  min_x, max_x = claims.map { |c| [c[:x], c[:x] + c[:width] - 1] }.flatten.minmax
  min_y, max_y = claims.map { |c| [c[:y], c[:y] + c[:height] - 1] }.flatten.minmax
  # area = claims.sum { |c| c[:width] * c[:height] }
  # 486775
  # p area

  width = max_x - min_x + 1
  height = max_y - min_y + 1

  # 999000
  # p width * height
  cover = Array.new(height) { Array.new(width) {0} }

  claims.each do |claim|
    grid_x = claim[:x] - min_x
    grid_y = claim[:y] - min_y
    claim[:width].times do |dx|
      claim[:height].times do |dy|
        cover[grid_y + dy][grid_x + dx] += 1
      end
    end
  end

  overlap = cover.sum do |row|
    row.count { |coverage| coverage >= 2 }
  end

  # puts display_grid(grid)
  overlap
end

if ARGV.include?('--test')
  Testing.expect(parse('example'), [
    { width: 4, height: 4, x: 1, y: 3 },
    { width: 4, height: 4, x: 3, y: 1 },
    { width: 2, height: 2, x: 5, y: 5 }
  ])

  Testing.summary
end

p part_1_naive
