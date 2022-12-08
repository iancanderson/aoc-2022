require "active_support/all"

rows = File.readlines("day08.txt").map do |line|
  line.chomp.chars.map(&:to_i)
end

def interior_visible_tree_count(rows)
  (1..rows.size-2).sum do |row|
    (1..rows[row].size-2).count do |col|
      height = rows[row][col]

      trees_left = rows[row][0...col]
      trees_right = rows[row][col+1..]
      trees_above = rows[0...row].map { |r| r[col] }
      trees_below = rows[row+1..].map { |r| r[col] }

      trees_left.all? { |tree| tree < height } ||
        trees_right.all? { |tree| tree < height } ||
        trees_above.all? { |tree| tree < height } ||
        trees_below.all? { |tree| tree < height }
    end
  end
end

# how many trees are visible from outside the grid?
def part1(rows)
  corners = 4
  trees_on_edges = rows.size * 2 + rows.first.size * 2 - corners
  trees_on_edges + interior_visible_tree_count(rows)
end

puts part1(rows)
