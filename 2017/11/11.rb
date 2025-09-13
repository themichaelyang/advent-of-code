# https://adventofcode.com/2017/day/11

def read_input(name='input')
  file = File.open(name)
  file.read.strip.split(',')
end

def part_1
  distance(*walk(read_input).to_a.last)
end

def part_2
  walk(read_input).map { |x, y| distance(x, y) }.max
end

def walk(path, &blk)
  return to_enum(:walk, path) unless block_given?

  x, y = [0, 0]
  yield [x, y]

  path.each do |p|
    case p
    when 'n' then y = y + 1
    when 'ne' then x, y = ne(x, y)
    when 'nw' then x, y = nw(x, y)
    when 's' then y = y - 1
    when 'se' then x, y = se(x, y)
    when 'sw' then x, y = sw(x, y)
    end

    yield [x, y]
  end
end

def ne(x, y)
  if x.even?
    [x + 1, y]
  else
    [x + 1, y + 1]
  end
end

def nw(x, y)
  if x.even?
    [x - 1, y]
  else
    [x - 1, y + 1]
  end
end

def se(x, y)
  if x.even? then
    [x + 1, y - 1]
  else
    [x + 1, y]
  end
end

def sw(x, y)
  if x.even?
    [x - 1, y - 1]
  else
    [x - 1, y]
  end
end

def distance(x, y)
  if y < 0
    # We have access to down diagonals starting on (0, 0)
    x.abs + y.abs - [x.abs.div(2) + 1, y.abs].min
  else
    x.abs + y.abs - [x.abs.div(2), y.abs].min
  end
end

puts part_1
puts part_2