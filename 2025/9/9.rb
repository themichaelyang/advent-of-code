
# typed: true

module Advent2025; end

module Advent2025::Day9
  include Kernel

  #: (String) -> Array[[Integer, Integer]]
  def parse_input(input)
    coords = input.split.map do |line|
      line.split(',').map(&:to_i)
    end #: as Array[[Integer, Integer]]
  end

  class Part1
    extend Advent2025::Day9

    #: () -> Integer
    def self.solve
      input = File.open('input').read
      coords = parse_input(input)
      coords.permutation(2).map do |c1, c2|
        x1, y1 = c1 #: as [Integer, Integer]
        x2, y2 = c2 #: as [Integer, Integer]
        [(x1 - x2 + 1).abs * (y1 - y2 + 1).abs, c1, c2]
      end.max&.first #: as Integer
    end
  end

  class Part2
    extend Advent2025::Day9

    def self.solve
      input = File.open('example').read
    end
  end
end

p Advent2025::Day9::Part1.solve
# p Advent2025::Day9::Part2.solve
