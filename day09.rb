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

head = Location.new(x: 0, y: 0)
tail = Location.new(x: 0, y: 0)
tail_locations = Set.new

print_grid = lambda do
  [4,3,2,1,0].each do |y|
    (0..5).each do |x|
      if head.x == x && head.y == y
        print "H"
      elsif tail.x == x && tail.y == y
        print "T"
      elsif x == 0 && y == 0
        print "s"
      else
        print "."
      end
    end
    puts
  end
  puts
end

motions.each do |motion|
  puts "== #{motion.direction} #{motion.amount} =="

  motion.amount.times do
    case motion.direction
    when "U" then head.move_up
    when "D" then head.move_down
    when "R" then head.move_right
    when "L" then head.move_left
    end

    unless head.adjacent?(tail)
      if head.y == tail.y
        if head.x > tail.x + 1
          tail.x += 1
        elsif head.x < tail.x - 1
          tail.x -= 1
        end
      elsif head.x == tail.x
        if head.y > tail.y + 1
          tail.y += 1
        elsif head.y < tail.y - 1
          tail.y -= 1
        end
      else
        if head.x > tail.x
          tail.x += 1
        else
          tail.x -= 1
        end
        if head.y > tail.y
          tail.y += 1
        else
          tail.y -= 1
        end
      end
    end

    tail_locations << tail.dup
    # print_grid.call
  end
end

puts "Part 1: #{tail_locations.size}"
