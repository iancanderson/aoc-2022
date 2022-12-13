require "active_support/all"

class Day13
  def self.in_right_order?(left, right)
    lval = left.shift
    return true if lval.nil?

    rval = right.shift
    return false if rval.nil?

    if lval.is_a?(Integer) && rval.is_a?(Integer)
      if lval < rval
        return true
      elsif lval > rval
        return false
      else
        in_right_order?(left, right)
      end
    else
      in_right_order?(Array(left), Array(right))
    end
  end
end

Pair = Struct.new(:left, :right, keyword_init: true) do
  def in_right_order?
    Day13.in_right_order?(left, right)
  end
end

pairs = File.readlines("day13.txt", chomp: true).in_groups_of(3).map do |left, right, _|
  Pair.new(left: JSON.parse(left), right: JSON.parse(right))
end

puts pairs.inspect

part1 = pairs.count(&:in_right_order?)
puts "Part 1: #{part1}"
