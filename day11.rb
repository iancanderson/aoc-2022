require "active_support/all"

Monkey = Struct.new(:items, :operation, :operand, :test_div, :test_true, :test_false, :inspections, keyword_init: true) do
  def inspect_item(item)
    num =
      case operand
      when "old" then item
      else
        operand.to_i
      end

    item.public_send(operation, num)
  end

  def monkey_to_throw_to(item)
    if item % test_div == 0
      test_true
    else
      test_false
    end
  end
end

monkeys = File.readlines("day11.txt", chomp: true).in_groups_of(7).map do |lines|
  items = lines[1][18..].split(", ").map(&:to_i)
  operation = lines[2][23]
  operand = lines[2][25..]
  test_div = lines[3][21..].to_i
  test_true = lines[4][29..].to_i
  test_false = lines[5][30..].to_i

  Monkey.new(
    items: items,
    operation: operation,
    operand: operand,
    test_div: test_div,
    test_true: test_true,
    test_false: test_false,
    inspections: 0,
  )
end

puts monkeys

verbose = true

20.times do
  monkeys.each_with_index do |monkey, m|
    puts "Monkey #{m} has #{monkey.items}" if verbose

    monkey.items.each do |item|
      puts "Monkey #{m} inspects #{item}" if verbose

      # monkeys inspects item: get worried and increment inspection count
      item = monkey.inspect_item(item)
      monkey.inspections += 1

      puts "Worry level increased to #{item}" if verbose

      # relieved: divide worry level by 3
      item = item / 3

      puts "Worry level decreased to #{item}" if verbose

      # test for worry level to see which monkey to throw to
      dest_monkey = monkey.monkey_to_throw_to(item)

      puts "Throwing to monkey #{dest_monkey}"

      monkeys[dest_monkey].items << item
    end

    monkey.items = []
    puts
    puts
  end
end

part1 = monkeys.map(&:inspections).sort.last(2).inject(:*)

# What is the level of monkey business after 20 rounds of stuff-slinging simian shenanigans?
puts "Part 1: #{part1}"
