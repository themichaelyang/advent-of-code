def read_input
  file = File.open('input')
  lines = file.read
end

def part_1
  # input = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
  input = read_input
  multiples = input.scan(/mul\((\d+),(\d+)\)/)
  multiples.map do |pair|
    pair[0].to_i * pair[1].to_i
  end.sum
end

MULTI_REGEX = /mul\((\d+),(\d+)\)/
DO_REGEX = /do\(\)/
DONT_REGEX = /don't\(\)/
TYPE_TO_REGEX = {
  multi: MULTI_REGEX,
  do: DO_REGEX,
  dont: DONT_REGEX
}

def part_2
  # input = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
  input = read_input

  enabled = true
  sum = 0
  i = 0
  
  while i < input.length
    next_multi = input.index(MULTI_REGEX, i) || input.length + 1
    next_do = input.index(DO_REGEX, i) || input.length + 1
    next_dont = input.index(DONT_REGEX, i) || input.length + 1

    next_up = [[next_multi, :multi], [next_do, :do], [next_dont, :dont], [input.length, :nothing]].sort.first

    type = next_up.last
    next_index = next_up.first
    regex = TYPE_TO_REGEX[type]

    if regex
      match = input.match(regex, i)&.to_a

      if type == :multi 
        if enabled && match
          nums = match.to_a[1..-1].map(&:to_i)
          sum += nums[0] * nums[1]
        end      
      elsif type == :do 
        enabled = true
      elsif type == :dont 
        enabled = false
      end

      i = next_index + (match&.first.length || 0)
    else
      i += 1
    end

    # puts [i, next_up, match, match&.first.length].inspect
  end

  sum
end

puts "part 1: #{part_1}"
puts "part 2: #{part_2}"