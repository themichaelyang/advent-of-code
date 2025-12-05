# typed: true

module Advent2025
  module Part1
    include Kernel

    def self.read_input
      file = File.open('input')
      input = file.read
    end

    def self.solve
      position = 50
      at_zero = 0

      lines = read_input.split
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
end

p Advent2025::Part1.solve
