# typed: true

module Advent2025
  module Day7
    include Kernel

    #: () -> String
    def read_input
      file = File.open('input')
      input = file.read
    end

    class Part1
      extend Day7

      #: (String, String) -> Array[Integer]
      def self.all_index(str, char)
        i = -1 #: Integer?
        indices = []
        # typed to appease Sorbet
        while i = str.index(char, i.nil? ? str.length : i + 1)
          indices.push(i)
        end
        indices
      end

      def self.solve
        lines = read_input.split
        start = lines.first&.index('S') or raise "No start found"
        beams = [start] #: Array[Integer]
        splits = 0

        lines.each do |line|
          beams.each do |b|
            case line[b]
            when '.', 'S' then line[b] = '|'
            when '^'
              line[b - 1] = '|'
              line[b + 1] = '|'
              splits += 1
            end
          end
          p line
          beams = all_index(line, '|')
        end

        splits
      end
    end

    class Part2
      extend Day7

      def self.solve
      end
    end
  end
end

p Advent2025::Day7::Part1.solve
p Advent2025::Day7::Part2.solve
