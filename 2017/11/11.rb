# https://adventofcode.com/2017/day/11

def read_input(name='input')
  file = File.open(name)
  file.read.strip.split(',')
end

def part_1
  path = read_input
  x, y = [0, 0]

  path.each do |p|
    case p
    when 'n' then y = y + 1
    when 'ne' then x, y = ne(x, y)
    when 'nw' then x, y = nw(x, y)
    when 's' then y = y - 1
    when 'se' then x, y = se(x, y)
    when 'sw' then x, y = sw(x, y)
    end
  end 

  p [x, y]

  # x.abs + y.abs - [x.abs.div(2) + [[y, 1].max, 0].min, y.abs].min
  if y < 0
    # We have access to down diagonals starting on (0, 0)
    x.abs + y.abs - [x.abs.div(2) + 1, y.abs].min
  else
    x.abs + y.abs - [x.abs.div(2), y.abs].min
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

puts part_1