# typed: true

module Advent2025; end

module Advent2025::Day4
  include Kernel

  class Grid
    #: Integer
    attr_reader :width
    attr_reader :height

    #: (Array[Array[String]]) -> void
    def initialize(grid)
      @grid = grid          #: Array[Array[String]]
      raise "invalid first row" unless width = grid.first&.length
      @width = width
      @height = grid.length
    end

    #: (Integer, Integer) -> String?
    def get(x, y)
      return nil if x < 0 || x >= @width
      return nil if y < 0 || y >= @height

      @grid.dig(y, x)
    end
  end

  class Part1
    #: (Grid, Integer, Integer) -> Integer
    def self.count_adjacent(grid, x, y)
      [-1, 0, 1].repeated_permutation(2).sum do |delta|
        dx, dy = delta #: as [Integer, Integer]
        grid.get(x + dx, y + dy) == '@' ? 1 : 0
      end - 1
    end

    #: () -> Integer
    def self.solve
      input = File.open('input').read
      grid = Grid.new(input.split.map { |line| line.chars })

      adjacents = grid.height.times.flat_map do |y|
        grid.width.times.flat_map do |x|
          count_adjacent(grid, x, y) if grid.get(x, y) == '@'
        end
      end

      adjacents.compact.select {|a| a < 4}.count
    end
  end

  class Part2
    def self.solve
      input = File.open('input').read
    end
  end
end

p Advent2025::Day4::Part1.solve
# puts Advent2025::Day4::Part2.solve
