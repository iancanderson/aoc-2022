require "active_support/all" # for Range#overlaps?

class ElfPair
  def initialize(elf1_range, elf2_range)
    @elf1_range = elf1_range
    @elf2_range = elf2_range
  end

  def overlaps?
    @elf1_range.overlaps?(@elf2_range)
  end
end

pairs = File.readlines("day04.txt").map do |line|
  rng1, rng2 = line.split(",").map do |rng|
    Range.new(*rng.split("-").map(&:to_i))
  end
  ElfPair.new(rng1, rng2)
end

puts pairs.count(&:overlaps?)
