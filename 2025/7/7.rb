# typed: true

module Advent2025
  module Day7
    include Kernel

    #: () -> String
    def read_input
      file = File.open('input')
      input = file.read
    end

    #: (String, String) -> Array[Integer]
    def all_index(str, char)
      i = -1 #: Integer?
      indices = []
      # typed to appease Sorbet
      while i = str.index(char, i.nil? ? str.length : i + 1)
        indices.push(i)
      end
      indices
    end

    class Part1
      extend Day7

      def self.solve
        lines = read_input.split
        first_line = lines.first or raise "No first line"
        start = first_line.index('S') or raise "No start found"
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
          # p line
          beams = all_index(line, '|')
        end

        splits
      end
    end

    class Part2
      extend Day7

      Path = Struct.new(:x, :prev, :ways)

      #: (Array[Path?], Integer, Path) -> Path
      def self.add_path(paths, i, current)
        path = paths[i]
        if path.nil?
          paths[i] = Path.new(i, [current], current.ways)
        else
          path.prev.push(current)
          path.ways += current.ways
        end
      end

      def self.solve
        lines = read_input.split

        # Appease Sorbet
        first_line = lines.first or raise "No first line"
        rest = lines[1..] or raise "No lines"
        start = first_line.index('S') or raise "No start found"

        paths = [nil] * first_line.length #: Array[Path?]
        paths[start] = Path.new(start, [], 1)
        splits = 0

        rest.each do |line|
          new_paths = [nil] * first_line.length #: Array[Path?]
          paths.compact.each do |p|
            b = p.x

            case line[b]
            when '.'
              add_path(new_paths, b, p)
            when '^'
              add_path(new_paths, b + 1, p)
              add_path(new_paths, b - 1, p)
            end
          end

          paths = new_paths
        end

        paths.compact.map(&:ways).sum
      end
    end
  end
end

p Advent2025::Day7::Part1.solve
p Advent2025::Day7::Part2.solve
