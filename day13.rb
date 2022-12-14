require "active_support/all"

class Day13
  def self.in_right_order?(left, right, depth = 0)
    # TODO: how to skip this iteration if both are empty?
    # return nil if left.empty? && right.empty?

    lval = left.shift
    if lval.nil?
      log "- Left side is empty, so inputs are in the right order", depth
      return true
    end

    rval = right.shift
    if rval.nil?
      log "- Right side is empty, so inputs are not in the right order", depth
      return false
    end

    if lval.is_a?(Integer) && rval.is_a?(Integer)
      log "- Compare #{lval} vs #{rval}", depth + 1
      if lval < rval
        log "Left side is smaller, so inputs are in the right order", depth + 2
        return true
      elsif lval > rval
        log "Right side is smaller, so inputs are not in the right order", depth + 2
        return false
      else
        in_right_order?(left, right)
      end
    elsif lval.is_a?(Array) && rval.is_a?(Array)
      log "- Compare #{lval} vs #{rval}", depth + 1
      # At least one is an array.
      # Make sure they're both arrays and try again
      in_right_order?(lval, rval, depth + 1) && in_right_order?(left, right, depth)
    else
      log "- Compare #{Array(lval)} vs #{Array(rval)}", depth + 1
      in_right_order?(Array(lval), Array(rval), depth + 1) && in_right_order?(left, right, depth + 1)
    end
  end

  def self.log(msg, depth)
    puts "#{'  ' * depth}#{msg}"
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


indices = []

part1 = pairs.each_with_index.sum do |pair, i|
  puts "\n== Pair #{i+1} =="
  puts "- Compare: #{pair.left} vs #{pair.right}"
  if pair.in_right_order?
    indices << i + 1
    i + 1
  else
    0
  end
end
puts "Part 1: #{part1}"

puts "#{pairs.size} pairs"
puts "#{indices}"
