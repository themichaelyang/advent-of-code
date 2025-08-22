# did this one in movie theater, started ~5-10 minutes late?
def read_input
  file = File.open('input')
  lines = file.read
end

def part_1
#   input = <<EOF
# ..X...
# .SAMX.
# .A..A.
# XMAS.S
# .X....
# EOF
#   input = <<EOF
# MMMSXXMASM
# MSAMXMSMSA
# AMXSXMAAMM
# MSAMASMSMX
# XMASAMXAMM
# XXAMMXXAMA
# SMSMSASXSS
# SAXAMASAAA
# MAMMMXMMMM
# MXMXAXMASX
# EOF
#   cleaned_input = <<EOF
# ....XXMAS.
# .SAMXMS...
# ...S..A...
# ..A.A.MS.X
# XMASAMX.MM
# X.....XA.A
# S.S.S.S.SS
# .A.A.A.A.A
# ..M.M.M.MM
# .X.X.XMASX
# EOF
  str = "XMAS" 
  # find_matches(input_to_lines(input), str) - find_matches(input_to_lines(cleaned_input), str)
  
  lines = input_to_lines(read_input)
  # lines = input_to_lines(input)
  find_matches(lines, str).count
end

def part_2
  sample_input = <<EOF
.M.S......
..A..MSMS.
.M.S.MAA..
..A.ASMSM.
.M.S.M....
..........
S.S.S.S.S.
.A.A.A.A..
M.M.M.M.M.
..........
EOF
  lines = input_to_lines(read_input)
  # lines = input_to_lines(input)
  # lines = input_to_lines(sample_input)
  total = []

  (0...lines.length).each do |y|
    (0...lines.first.length).each do |x|
      if lines[y][x] == 'A'
        mas_down_right = (get_from(lines, x - 1, y - 1) == 'M' && get_from(lines, x + 1, y + 1) == 'S')
        sam_down_right = (get_from(lines, x - 1, y - 1) == 'S' && get_from(lines, x + 1, y + 1) == 'M')

        
        mas_left_down = (get_from(lines, x + 1, y - 1) == 'S' && get_from(lines, x - 1, y + 1) == 'M')
        sam_left_down = (get_from(lines, x + 1, y - 1) == 'M' && get_from(lines, x - 1, y + 1) == 'S')

        total.append((mas_down_right || sam_down_right) && (mas_left_down || sam_left_down))
      end      
    end
  end

  total.count(true)
end

def get_from(lines, x, y)
  if x.between?(0, lines.first.length - 1) && y.between?(0, lines.length - 1)
    lines[y][x]
  else
    nil
  end
end

def input_to_lines(input)
  lines = input.split.map(&:chars)
end

def find_matches(lines, str)
  total = []

  (0...lines.length).each do |y|
    (0...lines.first.length).each do |x|
      total += [
        check_direction(lines, str, x, y, 1, 0),
        check_direction(lines, str, x, y, 0, 1),
        check_direction(lines, str, x, y, 1, 1),
        check_direction(lines, str, x, y, -1, 0),
        check_direction(lines, str, x, y, 0, -1),
        check_direction(lines, str, x, y, -1, -1),
        check_direction(lines, str, x, y, 1, -1),
        check_direction(lines, str, x, y, -1, 1)
      ].compact
    end
  end

  total
end

def check_direction(lines, str, x, y, x_diff, y_diff)
  matches = (0...str.length).each.map do |i|
    y_current = (y + (y_diff * i))
    x_current = (x + (x_diff * i))
    # works cause nil returns if oob

    # need to get rid of negatives because of negative indexing
    if x_current.between?(0, lines.first.length) && y_current.between?(0, lines.length)
      str[i] == lines.dig(y_current, x_current)
    else
      false
    end
  end.all?

  if matches 
    [x, y, x_diff, y_diff]
  else
    nil
  end
end

puts "part 1: #{part_1}"
puts "part 2: #{part_2}"
