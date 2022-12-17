require "set"

regex =  /(-?\d+)/

Sensor = Struct.new(:sx, :sy, :bx, :by) do
  def distance_to_beacon
    @distance_to_beacon ||= (bx - sx).abs + (by - sy).abs
  end

  def distance_to_row(y)
    (sy - y).abs
  end

  # Returns an array of [x, y] pairs that
  # represents the points in the detection area,
  # as determined by the distance_to_beacon
  def points_in_detection_area
    (top_row..bottom_row).flat_map do |row|
      x_distance_remaining = distance_to_beacon - distance_to_row(row)
      (sx - x_distance_remaining..sx + x_distance_remaining).map do |x|
        [x, row]
      end
    end
  end

  def top_row
    sy - distance_to_beacon
  end

  def bottom_row
    sy + distance_to_beacon
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

class Part2
  def initialize(sensors, coord_limit: 20)
    @sensors = sensors
    @points_where_beacon_cannot_be = Set.new
    @coord_limit = coord_limit
  end

  def tuning_frequency
    x, y = undetected_beacon
    x * 4000000 + y
  end

  def undetected_beacon
    # Fill in the points where the undetected_beacon cannot be
    @sensors.each_with_index do |sensor, i|
      puts "Sensor #{i}"
      @points_where_beacon_cannot_be += sensor.points_in_detection_area
      puts @points_where_beacon_cannot_be if i == 0
    end

    result = nil
    (0..@coord_limit).to_a.repeated_permutation(2) do |x, y|
      if !@points_where_beacon_cannot_be.include?([x, y])
        result = [x, y]
        break
      end
    end

    result
  end
end

puts "Part 2: #{Part2.new(sensors).tuning_frequency}"
