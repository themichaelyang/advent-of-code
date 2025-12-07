# typed: true

module Advent2025; end

module Advent2025::Day3
  include Kernel

  class Part1
    def self.solve
      input = File.open('input').read
      input.split.sum do |line|
        tens = line[0..-2]&.chars&.max     #: as String
        i = line.index(tens)               #: as Integer
        ones = line[(i + 1)..]&.chars&.max #: as String
        (tens + ones).to_i
      end
    end
  end

  class Part2
    def self.solve
      input = File.open('input').read
      input.split.sum do |line|
        i = -1
        12.times.map do |place|
          digit = line[(i + 1)..(-12 + place)]&.chars&.max  #: as String
          i = line.index(digit, i + 1)                      #: as Integer

          digit
        end.join.to_i
      end
    end
  end
end

puts Advent2025::Day3::Part1.solve
puts Advent2025::Day3::Part2.solve
