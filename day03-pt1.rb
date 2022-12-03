class Rucksack
  def initialize(compartment1, compartment2)
    @compartment1 = compartment1
    @compartment2 = compartment2
  end

  def priority
    ord = item_to_swap.ord
    ord < 97 ? ord - 38 : ord - 96
  end

  private

  def item_to_swap
    (@compartment1 & @compartment2).first
  end
end

rucksacks = File.readlines('day03.txt').map do |line|
  # Break the line into 2 equal halves
  part1, part2 = line.chars.each_slice(line.size/2).map(&:join)
  Rucksack.new(part1.chars, part2.chars)
end

puts rucksacks.sum(&:priority)
