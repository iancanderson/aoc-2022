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

def viewing_distance(house_height, trees)
  if trees.empty?
    0
  else
    smaller_trees_in_view = trees.take_while { |tree| tree < house_height }.size
    res = smaller_trees_in_view < trees.size ? smaller_trees_in_view + 1 : smaller_trees_in_view
    # puts "#{house_height} with #{trees} => #{res}"
    res
  end
end

# A tree's scenic score is found by multiplying together its viewing distance
# in each of the four directions
def scenic_score(rows, row, col)
  house_height = rows[row][col]
  trees_left = rows[row][0...col].reverse
  trees_right = rows[row][col+1..]
  trees_above = rows[0...row].map { |r| r[col] }.reverse
  trees_below = rows[row+1..].map { |r| r[col] }

  viewing_distance(house_height, trees_left) *
    viewing_distance(house_height, trees_right) *
    viewing_distance(house_height, trees_above) *
    viewing_distance(house_height, trees_below)
end

# What is the highest scenic score possible for any tree?
def part2(rows)
  scenic_scores = []
  (0...rows.size).each do |row|
    (0...rows[row].size).each do |col|
      scenic_scores << scenic_score(rows, row, col)
    end
  end
  scenic_scores.max
end

# how many trees are visible from outside the grid?
def part1(rows)
  corners = 4
  trees_on_edges = rows.size * 2 + rows.first.size * 2 - corners
  trees_on_edges + interior_visible_tree_count(rows)
end

puts part1(rows)
puts part2(rows)
