def is_safe_row(row)
  is_monotonic = row == row.sort || row == row.sort.reverse

  are_diffs_ok = row.each_cons(2).map do |current, after|
    diff = (current - after).abs
    diff >= 1 && diff <= 3
  end.all?

  is_monotonic && are_diffs_ok
end

def is_safe_row_with_removal(row)
  is_safe_row(row) || (0...row.length).map do |i|
    is_safe_row(clone_and_remove_index(row, i))
  end.any?
end

def is_safe_row_with_removal_fast(row)
  removal_candidates = []
  row.each_cons(3)
end

def clone_and_remove_index(arr, index)
  arr[0...index] + arr[(index  + 1)...arr.length]
end

def read_input
  file = File.open('input')
  lines = file.read

  rows = lines.split("\n").map do |row_str|
    row_str.split.map(&:to_i)
  end
end

def part_1
  rows = read_input

  rows.map {|row| is_safe_row(row)}.count {|bool| bool}
end

def part_2
  rows = read_input

  rows.map {|row| is_safe_row_with_removal(row)}.count {|bool| bool}
end

puts "part 1: #{part_1}"
puts "part 2: #{part_2}"