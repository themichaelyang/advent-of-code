def read_input(name='input')
  file = File.open(name)
  file.read.strip.chars.map(&:to_i)
end

def part_1
  arr = read_input
  arr.append(arr.last).each_cons(2).map(&:uniq).select {|cons| cons.length == 1}.sum {|val| val.first}
end

p part_1