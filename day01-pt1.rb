input = File.read("day01.txt")
inventories = input.split("\n\n").map do |i|
  i.split("\n").map(&:to_i)
end

biggest_inventory = inventories.max_by(&:sum)

puts biggest_inventory.sum
