def reactive?(pair)
  pair = pair.compact
  letter = pair.first.downcase
  pair.sort == [letter.upcase, letter]
end

def reaction_step(units)
  just_reacted = false
  changed = false

  unreacted_units = units.each_cons(2).map do |pair|
    if just_reacted
      just_reacted = false
      nil
    elsif reactive?(pair)
      just_reacted = true
      changed = true
      nil
    else
      pair.first
    end
  end.to_a

  unless just_reacted
    unreacted_units << units.last
  end

  result = unreacted_units.compact
  # p result.join

  [result, changed]
end

def react_polymer(polymer)
  units = polymer.chars
  changed = true

  while changed
    units, changed = reaction_step(units)
  end

  units
end

def single_pass_reaction(polymer)
  units = polymer.chars
  stack = [units.first]

  units.length.times do |i|
    char = units[i + 1]

    if stack.last && char && (stack.last.ord - char.ord).abs == 32
      stack.pop
    else
      stack.push(char)
    end
  end

  stack
end

def part_1(filename='input')
  # remove trailing newline!!
  react_polymer(File.read(filename).chomp).length
end

[
  ['Aa', ''], ['aA', ''], ['aAaA', ''], ['aAAa', ''], ['aAa', 'a'], ['aa', 'aa'],
  ['AA', 'AA'], ['aBAb', 'aBAb'], ['aBbbBA', ''], ['bbBB', ''], ['aacC', 'aa'],
  ['aAcC', ''], ['abcCBA', ''], ['dabAcCaCBAcCcaDA', 'dabCBAcaDA']
].each do |input, expected|
  raise unless react_polymer(input).join == expected
  raise unless single_pass_reaction(input).join == expected
end

require 'benchmark'

Benchmark.bm do |benchmark|
  benchmark.report('original') do
    100.times do
      react_polymer('dabAcCaCBAcCcaDA')
    end
  end

  benchmark.report('single pass') do
    100.times do
      single_pass_reaction('dabAcCaCBAcCcaDA')
    end
  end
end

# p part_1
