require "active_support/all"
require "set"

Point = Struct.new(:x, :y)
Path = Struct.new(:ends) do
  def points
    @points ||= begin
      points = ends
      ends.each_cons(2) do |start, finish|
        points += points_between(start, finish)
      end
      points
    end
  end

  def points_between(start, finish)
    points = []
    if start.x == finish.x
      yends = [start.y, finish.y].sort
      (yends.first..yends.second).each do |y|
        points << Point.new(start.x, y)
      end
    else
      xends = [start.x, finish.x].sort
      (xends.first..xends.second).each do |x|
        points << Point.new(x, start.y)
      end
    end
    points
  end
end

class Cave
  attr_reader :depth

  def initialize
    @stones = {}
    @sands = {}
    @depth = 0
    @min_x = Float::INFINITY
    @max_x = 0
  end

  def add_stone_path(path)
    path.points.each do |point|
      @stones[point.x] ||= Set.new
      @stones[point.x].add(point.y)

      @depth = point.y if point.y > @depth
      @min_x = point.x if point.x < @min_x
      @max_x = point.x if point.x > @max_x
    end
  end

  def add_sand(point)
    @sands[point.x] ||= Set.new
    @sands[point.x].add(point.y)

    @depth = point.y if point.y > @depth
    @min_x = point.x if point.x < @min_x
    @max_x = point.x if point.x > @max_x
  end

  def in_abyss?(y)
    @stones.values.all? { |ys| ys.max < y }
  end

  def air?(x, y)
    (@stones[x].nil? || !@stones[x].include?(y)) &&
      (@sands[x].nil? || !@sands[x].include?(y))
  end

  def to_s
    puts "Depth: #{@depth}"
    puts "Min x: #{@min_x}"
    puts "Max x: #{@max_x}"

    (0..@depth).map do |y|
      (@min_x..@max_x).map do |x|
        if air?(x, y)
          "."
        elsif @stones[x].include?(y)
          "#"
        else
          "o"
        end
      end.join("")
    end.join("\n")
  end
end

paths = File.readlines("day14.txt", chomp: true).map do |line|
  points = line.split(" -> ").map do |point|
    x, y = point.split(",").map(&:to_i)
    Point.new(x, y)
  end
  Path.new(points)
end

cave = Cave.new
paths.each do |path|
  cave.add_stone_path(path)
end

def spawn_sand
  # puts "Spawned a new unit of sand"
  Point.new(500, 0)
end

falling_sand = spawn_sand
units_of_sand_at_rest = 0

loop do
  if falling_sand.nil?
    falling_sand = spawn_sand
  end

  if cave.in_abyss?(falling_sand.y)
    puts "Fell into the abyss with y=#{falling_sand.y}"
    break
  end

  if cave.air?(falling_sand.x, falling_sand.y + 1)
    # move down
    falling_sand = Point.new(falling_sand.x, falling_sand.y + 1)
  elsif cave.air?(falling_sand.x - 1, falling_sand.y + 1)
    # move down and left
    falling_sand = Point.new(falling_sand.x - 1, falling_sand.y + 1)
  elsif cave.air?(falling_sand.x + 1, falling_sand.y + 1)
    # move down and right
    falling_sand = Point.new(falling_sand.x + 1, falling_sand.y + 1)
  else
    # sand rests: add it to the cave
    units_of_sand_at_rest += 1
    cave.add_sand(falling_sand)
    falling_sand = nil
  end
end

puts "Part 1: #{units_of_sand_at_rest}"

cave = Cave.new
paths.each do |path|
  cave.add_stone_path(path)
end

# Add floor for part 2
cave.add_stone_path(Path.new([
  Point.new(-1_000, cave.depth + 2),
  Point.new(1_000, cave.depth + 2),
]))

falling_sand = spawn_sand
units_of_sand_at_rest = 0
spawn_point = Point.new(500, 0)

loop do
  # puts cave.to_s

  if falling_sand.nil?
    falling_sand = spawn_sand
  end

  if cave.air?(falling_sand.x, falling_sand.y + 1)
    # move down
    falling_sand = Point.new(falling_sand.x, falling_sand.y + 1)
  elsif cave.air?(falling_sand.x - 1, falling_sand.y + 1)
    # move down and left
    falling_sand = Point.new(falling_sand.x - 1, falling_sand.y + 1)
  elsif cave.air?(falling_sand.x + 1, falling_sand.y + 1)
    # move down and right
    falling_sand = Point.new(falling_sand.x + 1, falling_sand.y + 1)
  else
    # sand rests: add it to the cave
    units_of_sand_at_rest += 1
    cave.add_sand(falling_sand)
    if !cave.air?(spawn_point.x, spawn_point.y)
      puts "Sand entrance is blocked"
      break
    end
    falling_sand = nil
  end
end

puts "Part 2: #{units_of_sand_at_rest}"
