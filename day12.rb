require "active_support/all"
require "set"

columns = File.readlines("day12.txt", chomp: true).map do |line|
  line.chars
end.transpose

class Grid
  def initialize(columns)
    @columns = columns
  end

  def find(val)
    res = nil
    @columns.each_with_index.each do |col, c|
      if r = col.index(val)
        res = [c, r]
        break
      end
    end
    res
  end

  def val(pos)
    x, y = pos
    return nil if x < 0 || y < 0
    return nil if x >= @columns.size || y >= @columns[0].size

    @columns[x][y]
  end

  def start
    @start ||= find("S")
  end

  def goal
    @goal ||= find("E")
  end

  def cols
    @columns.size
  end

  def rows
    @columns[0].size
  end

  def num_nodes
    cols * rows
  end

  def elevation(pos)
    v = val(pos)
    case v
    when "S" then "a"
    when "E" then "z"
    else
      v
    end
  end
end

class Graph
  def initialize(grid)
    @vertices = {}
  end
end

grid = Grid.new(columns)

# https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm
class Dijkstra
  def initialize(grid)
    @grid = grid
    @unvisited = Set.new
    @distance_from_start = {}

    (0...grid.cols).each do |x|
      (0...grid.rows).each do |y|
        @unvisited.add([x, y])
        @distance_from_start[[x, y]] = Float::INFINITY
      end
    end
    @distance_from_start[grid.start] = 0
  end

  # For the current node, consider all of its unvisited neighbors and calculate
  # their tentative distances through the current node. Compare the newly
  # calculated tentative distance to the one currently assigned to the neighbor
  # and assign it the smaller one. For example, if the current node A is marked
  # with a distance of 6, and the edge connecting it with a neighbor B has
  # length 2, then the distance to B through A will be 6 + 2 = 8. If B was
  # previously marked with a distance greater than 8 then change it to 8.
  # Otherwise, the current value will be kept.
  def shortest_path_length
    current_node = grid.start
    traverse(current_node)

    @grid.num_nodes - @unvisited.size - 1
  end

  private

  def traverse(current_node)
    puts "Traversing #{current_node}"

    current_distance_from_start = distance_from_start[current_node]
    neighbors = unvisited_neighbors(current_node)
    puts "Neighbors of #{current_node}: #{neighbors}"
    puts "Unvisited: #{@unvisited}"

    highest_valid_elevation = neighbors.map { |neighbor| grid.elevation(neighbor) }.max

    next_node = neighbors.select do |neighbor|
      grid.elevation(neighbor) == highest_valid_elevation
    end.min_by do |neighbor|
      distance_from_start[neighbor] = [distance_from_start[neighbor], current_distance_from_start + 1].min
    end
    @unvisited.delete(current_node)

    if done?
      return
    else
      puts
      traverse(next_node)
    end
  end

  def unvisited_neighbors(node)
    x, y = node
    [[x, y - 1], [x, y + 1], [x - 1, y], [x + 1, y]].select do |neighbor|
      can_travel?(node, neighbor)
    end
  end

  def can_travel?(from, to)
    return false unless grid.val(to)
    return false unless @unvisited.include?(to)

    from_val = grid.elevation(from)
    to_val = grid.elevation(to)
    next_val = from_val.succ

    elevation_okay = to_val == from_val || to_val == next_val
    elevation_okay
  end

  attr_reader :distance_from_start, :grid

  def done?
    !grid.goal.in?(@unvisited)
  end
end

def part1(grid)
  puts "Starting at #{grid.start}"
  puts "Goal at #{grid.goal}"

  shortest_path_length = Dijkstra.new(grid).shortest_path_length
  puts "Shortest path length: #{shortest_path_length}"
end

part1(grid)
