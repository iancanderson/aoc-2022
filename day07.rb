require "set"

module Node
  attr_reader :name, :parent, :level

  def root
    if parent
      parent.root
    else
      self
    end
  end

  def ==(other)
    name == other.name && parent == other.parent
  end
  alias_method :eql?, :==

  def hash
    [self.class, name, parent].hash
  end
end

class DirNode
  include Node

  attr_reader :children

  def initialize(name, parent, level)
    @name = name
    @parent = parent
    @level = level
    @children = Hash.new
  end

  def size
    @children.values.sum(&:size)
  end

  def add_child(dir_or_file)
    @children[dir_or_file.name] = dir_or_file
  end

  def child(name)
    @children[name]
  end

  def to_s
    "#{" " * @level * 2}- #{@name} (dir)\n" + @children.values.map { |child| "#{child}" }.join
  end

  def directory?
    true
  end

  def part1_size
    size <= 100000 ? size : 0
  end

  def all_child_dirs
    @children.values.select(&:directory?).flat_map { |dir| [dir] + dir.all_child_dirs }
  end
end

class FileNode
  include Node
  attr_reader :size

  def initialize(name, size, parent, level)
    @name = name
    @size = size
    @parent = parent
    @level = level
  end

  def to_s
    "#{" " * @level * 2}- #{@name} (file, size=#{@size})\n"
  end

  def directory?
    false
  end
end

class TreeBuilder
  def initialize(lines)
    @lines = lines
  end

  def build_tree
    @lines.map(&:chomp).each do |line|
      puts "Line: #{line}"

      if line.start_with?("$ cd ")
        process_cd(line)
      elsif line.start_with?("dir ")
        # ls result, directory
        dir_name = line[4..]
        maybe_add_dir(dir_name)
      elsif file_match = line.match(/\A(\d+)\s(.+)\z/)
        size, name = file_match.captures
        maybe_add_file(size.to_i, name)
      end
    end

    @tree.root
  end

  private

  def process_cd(line)
    dest = line[5..]

    if dest == ".."
      @tree = @tree.parent
    else
      @tree = maybe_add_dir(dest)
    end
  end

  def maybe_add_file(size, name)
    if node = @tree.child(name)
      node
    else
      puts "Adding file #{name} to dir #{@tree&.name}"
      @tree.add_child(FileNode.new(name, size, @tree, @tree.level + 1))
    end
  end

  def maybe_add_dir(dir_name)
    if !@tree
      DirNode.new(dir_name, nil, 0)
    else
      if node = @tree.child(dir_name)
        node
      else
        puts "Adding dir #{dir_name} to dir #{@tree&.name}"
        @tree.add_child(DirNode.new(dir_name, @tree, @tree.level + 1))
      end
    end
  end
end

tree = TreeBuilder.new(File.readlines("day07.txt")).build_tree
puts tree

class Part1
  def initialize(tree)
    @tree = tree
  end

  def result
    # find all of the directories with a total size of at most 100000, then calculate the sum of their total sizes
    @tree.part1_size + @tree.all_child_dirs.sum(&:part1_size)
  end
end

part1 = Part1.new(tree).result
puts "Part 1: #{part1}"
