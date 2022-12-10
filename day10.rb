require "active_support/all"

class Noop
  def cycles
    1
  end
end

Addx = Struct.new(:v) do
  def cycles
    2
  end
end

instructions = File.readlines("day10.txt", chomp: true).map do |line|
  if line == "noop"
    Noop.new
  else
    val = line.split.last.to_i
    Addx.new(val)
  end
end

cycle = 1
x = 1

important_cycles = [20, 60, 100, 140, 180, 220]

# Find the signal strength during the
# 20th, 60th, 100th, 140th, 180th, and 220th cycles.
# What is the sum of these six signal strengths?
part1 = instructions.sum do |instruction|
  instruction.cycles.times.with_index.sum do |_, i|
    result = if cycle.in?(important_cycles)
      # puts ({ cycle: cycle, instruction: instruction, x: x }.inspect)
      signal_strength = x * cycle
    else
      0
    end
    if i == 1
      x += instruction.v
    end
    cycle += 1
    result
  end
end

puts "Part 1: #{part1}"
