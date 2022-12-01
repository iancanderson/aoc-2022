input = File.read("day01.txt")
inventories = input.split("\n\n").map do |i|
  i.split("\n").map(&:to_i)
end

biggest_inventories = inventories.sort_by(&:sum).reverse.take(3)

puts biggest_inventories.sum(&:sum)
