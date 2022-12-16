require "set"

regex =  /(-?\d+)/

Sensor = Struct.new(:sx, :sy, :bx, :by) do
  def distance_to_beacon
    (bx - sx).abs + (by - sy).abs
  end

  def distance_to_row(y)
    (sy - y).abs
  end
end

sensors = File.readlines("day15.txt", chomp: true).map do |line|
  sx, sy, bx, by = line.scan(regex).map(&:first).map(&:to_i)
  Sensor.new(sx, sy, bx, by)
end

class Part1
  def initialize(sensors)
    @sensors = sensors
  end

  def num_points_where_beacon_cannot_be(row)
    xs = Set.new
    beacon_xs = Set.new
    sensors_to_consider(row).each do |sensor|
      if sensor.by == row
        beacon_xs << sensor.bx
      end
      to_row = sensor.distance_to_row(row)
      remaining = sensor.distance_to_beacon - to_row
      (sensor.sx - remaining..sensor.sx + remaining).each do |x|
        # puts "Can't be at #{x}, #{row} because of sensor #{sensor}"
        xs << x
      end
    end
    (xs - beacon_xs).size
  end

  def sensors_to_consider(row)
    # don't need to worry about sensors whose manhattan distance
    # to their beacon is less than the manhattan distance to the
    # current row (with the same x coord as the sensor)
    @sensors.reject do |sensor|
      sensor.distance_to_beacon < sensor.distance_to_row(row)
    end
  end
end

puts "Part 1: #{Part1.new(sensors).num_points_where_beacon_cannot_be(2000000)}"
