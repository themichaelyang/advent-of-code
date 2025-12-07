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

    #: (String) -> Array[Range[Integer]]
    def parse_input(input)
      range_literals = input.split(',')
      range_literals.map do |literal|
        low, high = literal.split('-').map(&:to_i)
        low..high
      end
    end

    class Part1
      extend Day2

      #: (String) -> [String, String]
      def self.split_string(str)
        [str[0...(str.length/2)], str[(str.length/2)..-1]] #: as [String, String]
      end

      #: (Integer) -> bool
      def self.repeated_once?(x)
        str = x.to_s
        if str.length % 2 == 0
          first, last = split_string(str)
          first == last
        else
          false
        end
      end

      def self.solve
        ranges = parse_input(read_input)
        ranges.flat_map do |r|
          r.select do |x|
            repeated_once?(x)
          end
        end.sum
      end
    end

    class Part2
      extend Day2

      #: (Integer) -> bool
      def self.repeated_any?(num)
        str = num.to_s
        1.upto(str.length / 2).any? do |substr_len|
          if str.length % substr_len == 0
            repeats = str.length / substr_len
            0.upto(substr_len - 1).all? do |i|
              repeats.times.all? do |section|
                str[i] == str[section * substr_len + i]
              end
            end
          end
        end
      end

      def self.solve
        ranges = parse_input(read_input)
        ranges.flat_map do |r|
          r.select { repeated_any?(_1) }
        end.sum
      end
    end
  end
end

p Advent2025::Day2::Part1.solve
p Advent2025::Day2::Part2.solve
