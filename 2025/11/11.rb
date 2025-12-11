# typed: true

module Advent2025; end

module Advent2025::Day11
  include Kernel

  #: (String) -> Hash[String, Array[String]]
  def parse(input)
    lines = input.split("\n")
    all_nodes = Set.new

    nodes = lines.to_h do |line|
      name, *connected_to = line.delete(':').split
      all_nodes += Set.new(connected_to)
      [name, connected_to] #: as [String, Array[String]]
    end

    all_nodes.each { |node| nodes[node] ||= [] }
    nodes
  end


  class Part1
    extend Advent2025::Day11

    def self.paths(from, to, nodes)
      return 1 if from == to
      nodes[from].sum {|n| paths(n, to, nodes)}
    end

    def self.solve
      nodes = parse(File.open('input').read)
      paths('you', 'out', nodes)
    end
  end

  class Part2
    extend Advent2025::Day11

    def self.solve
      input = File.open('example').read
    end
  end
end

p Advent2025::Day11::Part1.solve
# p Advent2025::Day11::Part2.solve
