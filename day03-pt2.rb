require "active_support/all"

class Group
  def initialize(rucksacks)
    @rucksacks = rucksacks
  end

  def badge_priority
    ord = badge.ord
    ord < 97 ? ord - 38 : ord - 96
  end

  private

  def badge
    @rucksacks.map(&:contents).inject(&:intersection).first
  end
end

class Rucksack
  attr_reader :contents
  def initialize(contents)
    @contents = contents
  end
end

rucksacks = File.readlines('day03.txt').map do |line|
  Rucksack.new(line.chars)
end

groups = rucksacks.in_groups_of(3).map do |group_rucksacks|
  Group.new(group_rucksacks)
end

puts groups.sum(&:badge_priority)
