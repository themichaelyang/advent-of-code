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

    #: (Range[Integer], Range[Integer]) -> Range[Integer]
    def self.merge(r1, r2)
      ([r1.min, r2.min].min)..([r1.max, r2.max].max)
    end

    #: (Range[Integer], Array[Range[Integer]]) -> Array[Range[Integer]]
    def self.consolidate(new_range, consolidated)
      # lowest existing range where min >= new_range.min
      insert_at = consolidated.bsearch_index { |c| c.min >= new_range.min } || consolidated.length

      if insert_at > 0
        lower = consolidated[insert_at - 1] #: as Range[Integer]

        if lower.overlap?(new_range)
          new_range = merge(lower, new_range)
          consolidated.delete_at(insert_at - 1)
          insert_at -= 1
        end
      end

      while (candidate = consolidated[insert_at]) && new_range.overlap?(candidate)
        new_range = merge(new_range, candidate)
        consolidated.delete_at(insert_at)
        candidate = consolidated[insert_at]
      end

      consolidated.insert(insert_at, new_range)
    end

    def self.solve
      input = File.open('input').read
      ranges, _ids = parse_input(input)

      consolidated = [] #: Array[Range[Integer]]

      ranges.each do |r|
        consolidated = consolidate(r, consolidated)
      end

      consolidated.sum(&:size)
    end
  end
end

p Advent2025::Day5::Part1.solve
p Advent2025::Day5::Part2.solve
