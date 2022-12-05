require "active_support/all"
require "awesome_print"

class Stack
  def initialize
    @ary = []
  end

  def push(el)
    @ary.push(el)
  end

  def pop(n)
    @ary.pop(n)
  end

  def peek
    @ary.last
  end
end

Instruction = Struct.new(:amount, :from, :to, keyword_init: true)
INSTRUCTION_REGEX = /move (?<amount>\d+) from (?<from>\d+) to (?<to>\d+)/

crates_top_down = []
instructions = []

File.readlines("day05.txt").each do |line|
  if line.include? "["
    # break up line into 4-character chunks
    row = line.chars.each_slice(4).map do |chunk|
      chunk[1].presence
    end
    crates_top_down << row
  elsif line.include? "move"
    INSTRUCTION_REGEX.match(line) do |m|
      instructions << Instruction.new(
        amount: m[:amount].to_i,
        from: m[:from].to_i - 1, # zero-index
        to: m[:to].to_i - 1,     # zero-index
      )
    end
  end
end

stack_count = crates_top_down.map(&:length).max
stacks = Array.new(stack_count) { Stack.new }

# Push crates onto stacks from bottom to top
crates_top_down.reverse.each do |row|
  row.each_with_index do |crate, index|
    stacks[index].push(crate) if crate
  end
end

instructions.each do |instruction|
  from_stack = stacks[instruction.from]
  to_stack = stacks[instruction.to]

  crates = Array(from_stack.pop(instruction.amount))
  crates.each do |crate|
    to_stack.push(crate)
  end
end

puts stacks.map(&:peek).join
