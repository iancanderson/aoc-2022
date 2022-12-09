require "active_support/all"
require "set"

Motion = Struct.new(:direction, :amount, keyword_init: true)
Location = Struct.new(:x, :y, keyword_init: true) do
  def move_up
    self.y += 1
  end
  def move_down
    self.y -= 1
  end
  def move_right
    self.x += 1
  end
  def move_left
    self.x -= 1
  end

  def adjacent?(other)
    (x - other.x).abs <= 1 && (y - other.y).abs <= 1
  end
end

motions = File.readlines("day09.txt", chomp: true).map do |line|
  direction, amount = line.match(/(\w+) (\d+)/).captures
  Motion.new(direction: direction, amount: amount.to_i)
end

def print_grid(knots)
  head = knots.first
  tail = knots.last

  [4,3,2,1,0].each do |y|
    (0..5).each do |x|
      current = knots.index { |knot| knot.x == x && knot.y == y }
      if current
        if current == 0
          print "H"
        else
          print current
        end
      else
        print "."
      end
    end
    puts
  end
  puts
end

def follow_the_leader(leader, follower)
  unless leader.adjacent?(follower)
    if leader.y == follower.y
      if leader.x > follower.x + 1
        follower.x += 1
      elsif leader.x < follower.x - 1
        follower.x -= 1
      end
    elsif leader.x == follower.x
      if leader.y > follower.y + 1
        follower.y += 1
      elsif leader.y < follower.y - 1
        follower.y -= 1
      end
    else
      if leader.x > follower.x
        follower.x += 1
      else
        follower.x -= 1
      end
      if leader.y > follower.y
        follower.y += 1
      else
        follower.y -= 1
      end
    end
  end
end

def run(knots, motions)
  tail_locations = Set.new
  head = knots.first
  tail = knots.last

  motions.each do |motion|
    puts "== #{motion.direction} #{motion.amount} =="

    motion.amount.times do
      case motion.direction
      when "U" then head.move_up
      when "D" then head.move_down
      when "R" then head.move_right
      when "L" then head.move_left
      end

      knots.each_cons(2) do |leader, follower|
        follow_the_leader(leader, follower)
      end

      tail_locations << tail.dup
      # print_grid(knots)
    end
  end

  tail_locations.size
end

def part1(motions)
  head = Location.new(x: 0, y: 0)
  tail = Location.new(x: 0, y: 0)
  tail_locations_size = run([head, tail], motions)
  puts "Part 1: #{tail_locations_size}"
end

def part2(motions)
  knots = 10.times.map { Location.new(x: 0, y: 0) }
  tail_locations_size = run(knots, motions)
  puts "Part 2: #{tail_locations_size}"
end

# part1(motions)
part2(motions)
