# typed: true

module Advent2025; end

module Advent2025::Day4
  include Kernel

  class Grid
    #: Integer
    attr_reader :width
    attr_reader :height
    attr_reader :grid

    #: (Array[Array[String]]) -> void
    def initialize(grid)
      @grid = grid #: Array[Array[String]]
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

    #: (Integer, Integer) -> String
    def get!(x, y)
      v = get(x, y)
      raise "nil value" if v.nil?
      v
    end

    #: (Integer, Integer, String) -> String
    def set(x, y, v)
      row = @grid[y] #: as Array[String]
      row[x] = v
    end
  end

  #: (Grid, Integer, Integer) -> Integer
  def count_adjacent(grid, x, y)
    [-1, 0, 1].repeated_permutation(2).sum do |delta|
      dx, dy = delta #: as [Integer, Integer]
      grid.get(x + dx, y + dy) == '@' ? 1 : 0
    end - 1
  end

  class Part1
    extend Advent2025::Day4

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
    extend Advent2025::Day4

    #: () -> Integer
    def self.solve
      input = File.open('input').read
      grid = Grid.new(input.split.map { |line| line.chars })
      grid_other = Grid.new(grid.grid)
      accessible = 0
      changed = true #: bool

      while changed
        changed = false
        grid.height.times.map do |y|
          grid.width.times.map do |x|
            if grid.get(x, y) == '@' && count_adjacent(grid, x, y) < 4
              grid_other.set(x, y, '.')
              accessible += 1
              changed = true
            else
              grid_other.set(x, y, grid.get!(x, y))
            end
          end
        end

        grid, grid_other = grid_other, grid
      end

      accessible
    end
  end
end

p Advent2025::Day4::Part1.solve
p Advent2025::Day4::Part2.solve
