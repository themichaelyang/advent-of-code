def part_1(filename = 'input')
  lines = File.open(filename).read.lines

  frequencies = lines.map do |l|
    l.strip.chars.group_by(&:itself)
  end

  twos = frequencies.count do |freq|
    freq.any? { |_char, occur| occur.count == 2 }
  end

  threes = frequencies.count do |freq|
    freq.any? { |_char, occur| occur.count == 3 }
  end

  twos * threes
end

def part_2(filename = 'input')
  lines = File.open(filename).read.lines.map(&:strip)

  one_off = lines.combination(2).select do |l1, l2|
    l1.length.times.count { |i| l1[i] != l2[i] } == 1
  end.first

  l1, l2 = one_off
  l1.chars.select.with_index do |c1, i|
    c1 == l2[i]
  end.join
end

p part_1
p part_2
