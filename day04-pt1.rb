class ElfPair
  def initialize(elf1_range, elf2_range)
    @elf1_range = elf1_range
    @elf2_range = elf2_range
  end

  def one_covers_another?
    @elf1_range.cover?(@elf2_range) || @elf2_range.cover?(@elf1_range)
  end
end

pairs = File.readlines("day04.txt").map do |line|
  rng1, rng2 = line.split(",").map do |rng|
    Range.new(*rng.split("-").map(&:to_i))
  end
  ElfPair.new(rng1, rng2)
end

puts pairs.count(&:one_covers_another?)
