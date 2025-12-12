# typed: true

module Advent2025; end

module Advent2025::DayN
  include Kernel

  class Part1
    extend Advent2025::DayN

    def self.solve
      input = File.open('example').read
    end
  end

  class Part2
    extend Advent2025::DayN

    def self.solve
      input = File.open('example').read
    end
  end
end

p Advent2025::DayN::Part1.solve
p Advent2025::DayN::Part2.solve
