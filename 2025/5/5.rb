# typed: true

module Advent2025; end

module Advent2025::Day5
  include Kernel

  #: (String) -> [Array[Range[Integer]], Array[Integer]]
  def parse_input(input)
    lines = input.split
    ranges = []
    ids = []

    lines.each do |line|
      if line.include?("-")
        min, max = line.split("-").map(&:to_i) #: as [Integer, Integer]
        ranges << (min..max)
      else
        ids << line.to_i
      end
    end

    [ranges, ids]
  end

  class Part1
    extend Advent2025::Day5

    def self.solve
      input = File.open('input').read
      ranges, ids = parse_input(input)

      ids.count do |id|
        ranges.any? do |r|
          r.include?(id)
        end
      end
    end
  end

  class Part2
    extend Advent2025::Day5

    def self.solve
      # input = File.open('example').read
    end
  end
end

p Advent2025::Day5::Part1.solve
p Advent2025::Day5::Part2.solve
