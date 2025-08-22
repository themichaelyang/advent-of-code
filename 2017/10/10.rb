# - circle of string with 256 marks

example_size = 5
example_lengths = '3,4,1,5'

def read_input
  File.open('input').read
end

def knot_hash(size, lengths)
  circle = (0...size).to_a
  skip, pos = 0, 0

  lengths.each do |len|
    # p circle
    reverse_part(circle, pos, len)

    pos += len + skip
    skip += 1
  end

  circle
end

def reverse_part(circle, first_pos, length)
  flips = (length / 2).floor
  first_i = wrap(first_pos, circle)
  last_i = wrap(first_i + length - 1, circle)

  # p ["r", first_pos, length, flips]
  0.upto(flips - 1) do |offset|
    i_1 = wrap(first_i + offset, circle)
    i_2 = wrap(last_i - offset, circle)

    # p ['i', i_1, i_2]

    tmp = circle[i_1]
    circle[i_1] = circle[i_2]
    circle[i_2] = tmp
  end
end

def wrap(i, circle)
  i % circle.length
end

# puts knot_hash(5, example_lengths.split.map(&:to_i)).inspect
puts knot_hash(256, read_input.split(',').map(&:to_i)).inspect



