class Array
  def insert_after(i, value)
    insert(i + 1, value)
  end
end

def spin(step_size, inserts)
  list = [0]
  pos = 0
  inserts.times do |i|
    value = i + 1
    pos = (pos + step_size) % list.length
    list.insert_after(pos, value)
    pos = pos + 1
  end

  [list, pos]
end

def part_1
  list, pos = spin(380, 2017)
  list[pos + 1]
end

def part_2(step_size, inserts)
  after_zero = nil
  pos = 0
  inserts.times do |i|
    value = i + 1
    pos = (pos + step_size) % value
    if pos == 0
      after_zero = value
    end
    pos = pos + 1
  end

  after_zero
end

p part_1
p part_2(380, 50_000_000)