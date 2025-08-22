def distance(left, right)
  right_sorted = right.sort
  left.sort.each_with_index.map do |l, i|
    (right_sorted[i] - l).abs
  end.sum
end

def similarity(left, right)
  right_counts = right.tally
  left.map do |l|
    l * (right_counts[l] || 0)
  end.sum
end

file = File.open('input')
lines = file.read

left_list = []
right_list = []

lines.split("\n").each_with_index do |row, i|
  left, right = row.split
  left_list[i] = left.to_i
  right_list[i] = right.to_i
end

puts distance(left_list, right_list)
puts similarity(left_list, right_list)
