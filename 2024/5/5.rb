# started this one late, at 12:49 AM!

def read_input
  file = File.open('input')
  input = file.read
end

def sample_input 
  <<EOF
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
EOF
  end

def parse_input(input)
  rules_input, updates_input = input.split("\n\n")

  rules_lines = rules_input.split("\n")
  rules = rules_lines.map {|rule_line| rule_line.split("|").map(&:to_i)}
  updates = updates_input.split.map {|update_line| update_line.split(",").map(&:to_i)}

  {
    rules: rules,
    updates: updates
  }
end

def follows_rules?(update, rules)
  page_to_index = {}
  update.each_with_index do |page, i|
    page_to_index[page] = i
  end

  rules.map do |rule|
    before, after = rule

    if page_to_index.include?(before) && page_to_index.include?(after)
      before_i = page_to_index[before]
      after_i = page_to_index[after]

      before_i < after_i
    else
      # passes rule since rule doesn't apply
      true
    end
  end.all?
end

def find_middle_page(update)
  update[(update.length / 2).floor]
end

def part_1
  rules, updates = parse_input(read_input).values_at(:rules, :updates)

  follows_rules = updates.map {|update| follows_rules?(update, rules)}
  indexes_follows_rules = follows_rules.each_index.select {|i| follows_rules[i]}

  indexes_follows_rules.map {|i| find_middle_page(updates[i])}.sum
end

# topo sort!
require 'tsort'

class Ordering < Hash
  include TSort
  alias tsort_each_node each_key
  def tsort_each_child(node, &block)
    fetch(node).each(&block)
  end

  def self.from_rules(update, rules)
    ordering = Ordering.new()

    update.each do |page|
      ordering[page] ||= []
    end

    rules.each do |rule|
      before, after = rule
      ordering[before] ||= []
      ordering[before].append(after)
    end

    ordering
  end
end

def reorder_update(update, rules)
  # filter rules to just rules for update
  rules_for_update = rules.select do |rule|
    before, after = rule
    update.include?(before) && update.include?(after)
  end  

  # can there be multiple right answers? i think not, which is why
  # we must have only one unique answer and there must always be a rule
  # that applies to the ordering
  # Ordering.from_rules(rules_for_update).tsort
  Ordering.from_rules(update, rules_for_update).tsort.select {|value| update.include?(value)}
end 

def part_2
  rules, updates = parse_input(read_input).values_at(:rules, :updates)

  follows_rules = updates.map {|update| follows_rules?(update, rules)}
  indexes_breaks_rules = follows_rules.each_index.select {|i| !follows_rules[i]}

  indexes_breaks_rules.map do |i| 
    find_middle_page(reorder_update(updates[i], rules))
  end.sum
end


puts "part 1: #{part_1}"
puts "part 2: #{part_2}"
