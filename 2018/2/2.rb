def part_1(filename = 'input')
  lines = File.readlines(filename).map(&:strip)

  frequencies = lines.map do |l|
    l.chars.tally
  end

  twos = frequencies.count do |freq|
    freq.any? { |_char, occur| occur == 2 }
  end

  threes = frequencies.count do |freq|
    freq.any? { |_char, occur| occur == 3 }
  end

  twos * threes
end

def part_2(filename = 'input')
  lines = File.readlines(filename).map(&:strip)

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
