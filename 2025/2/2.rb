# typed: true

module Advent2025
  module Day2
    include Kernel

    def read_input
      file = File.open('input')
      input = file.read
    end

    def read_example
      '11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124'
    end

    class Part1
      extend Day2

      #: (String) -> Array[Range[Integer]]
      def self.parse_input(input)
        range_literals = input.split(',')
        range_literals.map do |literal|
          low, high = literal.split('-').map(&:to_i)
          low..high
        end
      end

      #: (String) -> [String, String]
      def self.split_string(str)
        [str[0...(str.length/2)], str[(str.length/2)..-1]] #: as [String, String]
      end

      def self.solve
        ranges = parse_input(read_input)
        ranges.flat_map do |r|
          r.select do |x|
            str = x.to_s
            if str.length % 2 == 0
              first, last = split_string(str)
              first == last
            end
          end
        end.sum
      end
    end

    class Part2
      extend Day2

      def self.solve
      end
    end
  end
end

p Advent2025::Day2::Part1.solve
p Advent2025::Day2::Part2.solve
