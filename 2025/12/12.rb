# typed: true

module Advent2025; end

module Advent2025::Day12
  include Kernel

  def parse(input)
    chunks = input.split("\n\n")
    tiles = chunks.take(6).map do |tile_str|
      tile_str.split("\n")[1..].map(&:chars)
    end

    regions = chunks.last.split("\n").map do |line|
      area, *spec = line.split
      width, height = area.delete(':').split('x').map(&:to_i)
      tile_counts = spec.map(&:to_i)

      {width: width, height: height, tile_counts: tile_counts}
    end

    [tiles, regions]
  end

  class Part1
    extend Advent2025::Day12

    def self.solve
      tiles, regions = parse(File.open('input').read)
      tile_areas = tiles.map(&:flatten).map { _1.count('#') }
      regions.count do |r|
        min_area = r[:tile_counts].map.with_index.sum { |tc, tci| tc * tile_areas[tci] }
        min_area <= r[:width] * r[:height]
      end
    end
  end

  class Part2
    extend Advent2025::Day12

    def self.solve
      # input = File.open('input').read
    end
  end
end

p Advent2025::Day12::Part1.solve
# p Advent2025::Day12::Part2.solve
