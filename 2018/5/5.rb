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
  p result.join

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

# def single_pass_reaction(units)
#   stack = []
#   units.length.times do |i|
#     next_unit = units[i]

#     if stack.last == 
#   end
# end

def part_1(filename='input')
  // remove trailing newline!!
  react_polymer(File.read(filename).chomp).length
end

raise unless react_polymer('Aa').join == ''
raise unless react_polymer('aA').join == ''
raise unless react_polymer('aAaA').join == ''
raise unless react_polymer('aAAa').join == ''
raise unless react_polymer('aAa').join == 'a'
raise unless react_polymer('aa').join == 'aa'
raise unless react_polymer('AA').join == 'AA'
raise unless react_polymer('aBAb').join == 'aBAb'
raise unless react_polymer('aBbbBA').join == ''
raise unless react_polymer('bbBB').join == ''
raise unless react_polymer('aacC').join == 'aa'
raise unless react_polymer('aAcC').join == ''
raise unless react_polymer('abcCBA').join == ''

raise unless react_polymer('dabAcCaCBAcCcaDA').join == 'dabCBAcaDA'
raise unless react_polymer('dabAcCaCBAcCcaDA').length == 10

require 'benchmark'

Benchmark.bm do |benchmark|
  benchmark.report('original') do
    100.times do
      react_polymer('dabAcCaCBAcCcaDA')
    end
  end
end

p part_1
