# typed: true

require 'bundler/setup'
require 'z3'

module Advent2025; end

module Advent2025::Day10
  include Kernel

  #: type machine = [
  #|   Array[bool],
  #|   Array[Array[Integer]],
  #|   Array[Integer]
  #| ]

  #: (String) -> Array[machine]
  def parse(input)
    lines = input.split("\n")
    lines.map do |line|
      words = line.split(' ')
      goal = words.first&.delete("[]")&.chars&.map { _1 == '#' } #: as Array[bool]

      # p words

      buttons = words[1..-2]&.map do |b|
        b[1..-2]&.split(',')&.map(&:to_i)
      end #: as Array[Array[Integer]]

      joltages = words.last&.delete("{}")
        &.split(',')&.map(&:to_i) #: as Array[Integer]

      [goal, buttons, joltages]
    end
  end

  class Part1
    extend Advent2025::Day10

    def self.solve
      parse(File.open('input').read).sum do |goal, buttons, _joltages|
        num_lights = goal.length
        buttons_for_light = num_lights.times.map { Array.new }
        button_vars = []

        button_vars = buttons.each_with_index.map do |_btn, bi|
          Z3.Bool("btn_#{bi}")
        end

        buttons.each_with_index do |btn, bi|
          btn.each do |light|
            buttons_for_light[light] << button_vars[bi]
          end
        end

        light_vars = num_lights.times.map do |light|
          buttons_for_light[light].reduce do |acc, bvar|
            acc = Z3.Xor(bvar, acc)
          end
        end

        sat_conditions = goal.each_with_index.map do |on, light|
          if on
            light_vars[light]
          else
            !light_vars[light]
          end
        end

        optimizer = Z3::Optimize.new
        sat_conditions.each { |cond| optimizer.assert(cond) }
        cost = button_vars.reduce(0) { |acc, bvar| acc + Z3.IfThenElse(bvar, 1, 0) }

        optimizer.minimize(cost)
        model = []
        if optimizer.satisfiable?
          optimizer.model.each do |var, state|
            model[var.to_s["btn_".length..].to_i] = state.to_b
          end
        else
          raise "unsatisfiable!"
        end

        model.count(true)
      end
    end
  end

  class Part2
    extend Advent2025::Day10

    def self.solve
      input = File.open('example').read
    end
  end
end

p Advent2025::Day10::Part1.solve
# p Advent2025::Day10::Part2.solve
