def read_input(name='input')
  file = File.open(name)
  file.read.strip.chars.map(&:to_i)
end

def part_1
  arr = read_input
  arr.append(arr.last).each_cons(2).map(&:uniq).select {|cons| cons.length == 1}.sum {|val| val.first}
end

def part_2
  arr = read_input
  arr.each_with_index.sum do |v, i|
    check = (i + arr.length / 2) % arr.length

    if arr[i] == arr[check]
      arr[i]
    else
      0
    end
  end
end

p part_1
p part_2