# typed: true

module Advent2025; end
module Advent2025::Day6
  include Kernel

  #: (Array[Array[Integer]], Array[String], Integer) -> Integer
  def crunch(nums, ops, equation_count)
    equation_count.times.sum { |i|
      nums[i]&.reduce { |acc, val|
        op = ops[i]&.to_sym #: as Symbol
        acc.send(op, val)
      }
    }
  end

  class Part1
    extend Advent2025::Day6

    #: (String) -> [Array[Array[Integer]], Array[String], Integer]
    def self.parse(input)
      components = input.split("\n").map(&:split)
      nums = components[..-2]&.map { |row| row.map(&:to_i) }#: as Array[Array[Integer]]
      ops = components.last #: as Array[String]
      count = nums.first&.length #: as Integer
      [nums.transpose, ops, count]
    end

    def self.solve
      input = File.open('input').read
      nums, ops, equation_count = parse(input)
      crunch(nums, ops, equation_count)
    end
  end

  class Part2
    extend Advent2025::Day6

    #: (String) -> [Array[Array[Integer]], Array[String], Integer]
    def self.parse(input)
      lines = input.split("\n")
      chars = lines.map(&:chars)
      width = lines.map(&:length).max #: as Integer

      nums = [[]]
      width.times do |x|
        word = []
        lines.length.times do |y|
          char = chars.dig(y, x) #: as String
          if /\d/.match? char
            word << char
          end
        end

        if word == []
          nums.append([])
        else
          nums.last << word.join.to_i
        end
      end
      ops = lines.last&.split #: as Array[String]

      [nums, ops, nums.length]
    end

    def self.solve
      input = File.open('input').read
      nums, ops, equation_count = parse(input)
      crunch(nums, ops, equation_count)
    end
  end
end

p Advent2025::Day6::Part1.solve
p Advent2025::Day6::Part2.solve
