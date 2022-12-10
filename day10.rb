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
# part1 = instructions.sum do |instruction|
#   instruction.cycles.times.with_index.sum do |_, i|
#     result = if cycle.in?(important_cycles)
#       # puts ({ cycle: cycle, instruction: instruction, x: x }.inspect)
#       signal_strength = x * cycle
#     else
#       0
#     end
#     if i == 1
#       x += instruction.v
#     end
#     cycle += 1
#     result
#   end
# end

# puts "Part 1: #{part1}"

crt_row = 0
crt_col = 0

crt = 6.times.map do
  "." * 40
end

instructions.each do |instruction|
  instruction.cycles.times.with_index do |_, cycle_index_within_instruction|
    print_cycle = false # cycle < 20
    puts "Start cycle #{cycle}" if print_cycle

    # beginning of the cycle

    # during the cycle
    sprite_positions = [x - 1, x, x + 1]
    puts "Checking if crt_col #{crt_col} is in #{sprite_positions}" if print_cycle

    if crt_col.in?(sprite_positions)
      crt[crt_row][crt_col] = "#"
    end

    puts crt if print_cycle

    # end of the cycle
    if cycle_index_within_instruction == 1
      x += instruction.v
    end
    cycle += 1

    if crt_col < 39
      crt_col += 1
    else
      crt_col = 0
      crt_row += 1
    end
  end
end

puts crt
