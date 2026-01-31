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

def part_1_naive(filename='input')
  # remove trailing newline!!
  react_polymer(File.read(filename).chomp).length
end

def single_pass_reaction(polymer)
  units = polymer.chars
  stack = [units.first]

  units.length.times do |i|
    char = units[i + 1] # last one will be nil

    if char
      if stack.last && (stack.last.ord - char.ord).abs == 32
        stack.pop
      else
        stack.push(char)
      end
    end
  end

  stack
end

def part_1(filename='input')
  single_pass_reaction(File.read(filename).chomp).length
end

def part_2(filename='input')
  polymer = File.read(filename).chomp
  types = Set.new(polymer.chars.map(&:downcase))

  lengths = types.map do |type|
    [single_pass_reaction(polymer.delete(type + type.upcase)).length, type]
  end

  lengths.min
end

if ARGV.include?('--test')
  [
    ['Aa', ''], ['aA', ''], ['aAaA', ''], ['aAAa', ''], ['aAa', 'a'], ['aa', 'aa'],
    ['AA', 'AA'], ['aBAb', 'aBAb'], ['aBbbBA', ''], ['bbBB', ''], ['aacC', 'aa'],
    ['aAcC', ''], ['abcCBA', ''], ['dabAcCaCBAcCcaDA', 'dabCBAcaDA']
  ].each do |input, expected|
    raise unless react_polymer(input).join == expected
    raise unless single_pass_reaction(input).join == expected
  end
end

if ARGV.include?('--benchmark')
  require 'benchmark'

  Benchmark.bm do |benchmark|
    benchmark.report('naive') do
      part_1_naive
    end

    benchmark.report('single pass') do
      part_1
    end
  end
end

p part_1
p part_2
