# typed: true

module Advent2025
  module Day1
    include Kernel

    def self.read_input
      file = File.open('input')
      input = file.read
    end

    module Part1
      def self.solve
        position = 50
        at_zero = 0

        lines = Day1.read_input.split
        lines.map do |l|
          direction, distance = l[0], l[1..-1].to_i
          sign = if direction == 'R' then 1 else -1 end
          position += distance * sign
          position %= 100

          if position == 0
            at_zero += 1
          end
        end

        at_zero
      end
    end

    module Part2
      def self.solve
        position = 50
        passed_zero = 0

        lines = Day1.read_input.split
        lines.map do |l|
          direction, distance = l[0], l[1..-1].to_i
          sign = if direction == 'R' then 1 else -1 end
          q, r = distance.divmod(100)

          if direction == 'R'
            if r + position >= 100
              passed_zero += 1
            end
          else
            if position - r <= 0 && position != 0
              passed_zero += 1
            end
          end

          passed_zero += q
          position += distance * sign
          position %= 100
        end

        passed_zero
      end
    end
  end
end

p Advent2025::Day1::Part1.solve
p Advent2025::Day1::Part2.solve
