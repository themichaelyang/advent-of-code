# typed: true

module Advent2025; end
module Advent2025::Day6
  include Kernel

  #: (String) -> [Array[Array[Integer]], Array[String], Integer]
  def parse(input)
    components = input.split("\n").map(&:split)
    nums = components[..-2]&.map { |row| row.map(&:to_i) }#: as Array[Array[Integer]]
    ops = components.last #: as Array[String]
    count = nums.first&.length #: as Integer
    [nums.transpose, ops, count]
  end

  class Part1
    extend Advent2025::Day6

    def self.solve
      input = File.open('input').read
      nums, ops, equation_count = parse(input)
      equation_count.times.sum { |i|
        nums[i]&.reduce { |acc, val|
          op = ops[i]&.to_sym #: as Symbol
          acc.send(op, val)
        }
      }
    end
  end

  class Part2
    extend Advent2025::Day6

    def self.solve
      input = File.open('example').read
    end
  end
end

p Advent2025::Day6::Part1.solve
# p Advent2025::Day6::Part2.solve
