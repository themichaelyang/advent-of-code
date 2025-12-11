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

    def self.count_paths(from, to, nodes)
      return 1 if from == to
      nodes[from].sum {|n| count_paths(n, to, nodes)}
    end

    def self.solve
      nodes = parse(File.open('input').read)
      count_paths('you', 'out', nodes)
    end
  end

  class Part2
    extend Advent2025::Day11

    def self.count_paths_with(from, to, required, nodes, memoized={})
      return (required.empty? ? 1 : 0) if from == to
      return memoized[[from, required]] if memoized.include?([from, required])
      memoized[[from, required]] ||= nodes[from].sum {|n| count_paths_with(n, to, required - [from], nodes, memoized)}
    end

    def self.solve
      nodes = parse(File.open('input').read)
      count_paths_with('svr', 'out', ['dac', 'fft'], nodes)
    end
  end
end

p Advent2025::Day11::Part1.solve
p Advent2025::Day11::Part2.solve
