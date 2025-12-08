# typed: true

module Advent2025; end

module Advent2025::Day8
  include Kernel

  Node = Struct.new(:value, :parent, :size)

  #: [E]
  class UnionFind
    def initialize(values)
      @value_to_node = {} #: Hash[E, Node]
      values.each { |v| make_set(v) }
    end

    def make_set(value)
      @value_to_node[value] = Node.new(value, nil, 1)
    end

    #: (Node) -> Node
    def get_root(node)
      root = node

      until root.parent.nil?
        root = root.parent #: as Node
      end

      root
    end

    #: (Node) -> Node
    def compressed_root!(node)
      root = get_root(node)
      node.parent = root if root != node
      root
    end

    #: (E) -> Node
    def find_set(value)
      compressed_root!(@value_to_node[value] || make_set(value))
    end

    #: (E, E) -> Node
    def union_sets(v1, v2)
      node_1, node_2 = find_set(v1), find_set(v2)
      return node_1 if node_1 == node_2

      child, parent = [node_1, node_2].sort_by(&:size) #: as [Node, Node]

      parent.size = node_1.size + node_2.size
      child.parent = parent

      parent
    end

    #: () -> Array[Node]
    def roots
      @value_to_node.values.select { _1.parent.nil? }
    end
  end

  class Part1
    #: (Array[Integer], Array[Integer]) -> Numeric
    def self.distance(a, b)
      diffs = a.zip(b.map {-_1}).map(&:sum) #: as Array[Integer]
      squares = diffs.map {_1 * _1}
      Math.sqrt(squares.sum)
    end

    #: (?[String, Integer]) -> Integer
    def self.solve(params=['example', 10])
      file_name, connections = params
      input = File.open(file_name).read
      coords = input.split.map do |line|
        line.split(',').map(&:to_i)
      end

      distances = coords.combination(2).map do |pair|
        a, b = pair #: as [Array[Integer], Array[Integer]]
        if a != b
          [distance(a, b), a, b]
        end
      end.compact.sort

      uf = UnionFind.new(coords) #: UnionFind[Array[Integer]]
      distances.take(connections).each do |d|
        distance, a, b = d
        uf.union_sets(a, b)
      end

      uf.roots.map(&:size).sort.last(3)
        .reduce(&:*)
    end
  end
end

p Advent2025::Day8::Part1.solve(['input', 1000])
