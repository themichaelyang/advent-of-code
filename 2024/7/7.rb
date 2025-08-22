def read_input
  file = File.open('input')
  input = file.read
end

def sample_input 
  input = <<EOF
190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20
EOF
end

def parse_input(input)
  lines = input.split("\n")
  lines.map do |line|
    target_str, rest = line.split(":")
    values = rest.split.map(&:to_i)

    {target: target_str.to_i, values: values}
  end
end

def make_expr(values, operators)
  values = values.dup
  operators = operators.dup

  take_value = true
  expr = ""

  while values.length > 0 do
    if take_value
      expr += values.shift.to_s
    else
      expr += operators.shift.to_s
    end

    take_value = !take_value
  end

  expr
end

def evaluate_left_to_right(values, operators)
  output = values.first
  values = values.dup
  i = 1
  while i < values.length
    op = operators[i - 1]
    if op == :+
      output += values[i]
    elsif op == :*
      output *= values[i]
    elsif op == :|
      output = (output.to_s + values[i].to_s).to_i
    end

    i += 1
  end

  output
end

def part_1
  # input = sample_input
  input = read_input
  can_compute = parse_input(input).map do |attempt|
    target = attempt[:target]
    values = attempt[:values]

    operator_perms= [:+, :*].repeated_permutation(values.length - 1)
   
    operator_perms.map do |ops|
      expr = make_expr(values, ops)
      # {expr: expr, values: values, ops: ops}
      # actual = eval(expr)
      actual = evaluate_left_to_right(values, ops)
      {actual: actual, target: target, expr: expr, ops: ops}
      # actual == target
    end.select {|out| out[:actual] == out[:target]}
  end

  can_compute.sum do |c|
    if c.first
      c.first[:target]
    else
      0
    end
  end
end

def part_2
  input = read_input
  can_compute = parse_input(input).map do |attempt|
    target = attempt[:target]
    values = attempt[:values]

    operator_perms= [:+, :*, :|].repeated_permutation(values.length - 1)
   
    operator_perms.map do |ops|
      expr = make_expr(values, ops)
      # {expr: expr, values: values, ops: ops}
      # actual = eval(expr)
      actual = evaluate_left_to_right(values, ops)
      {actual: actual, target: target, expr: expr, ops: ops}
      # actual == target
    end.select {|out| out[:actual] == out[:target]}
  end

  can_compute.sum do |c|
    if c.first
      c.first[:target]
    else
      0
    end
  end
end

# puts "part 1: #{part_1}"
puts "part 2: #{part_2}"

