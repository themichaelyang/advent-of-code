def part_1(filename='input')
  File.readlines(filename).sum(&:to_i)
end

def part_2(filename='input')
  changes = File.readlines(filename).map(&:to_i)
  seen = Set.new
  frequency = 0
  i = 0

  until seen.include?(frequency)
    seen.add(frequency)
    frequency += changes[i]
    i += 1
    i = i % changes.length
  end

  frequency
end

p part_1
p part_2
