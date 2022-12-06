input_chars = File.read("day06.txt").chars

def chars_until_unique_chunk(input_chars, chunk_size)
  result = chunk_size - 1
  input_chars.each_cons(chunk_size).detect do |chunk|
    result += 1
    chunk.uniq.size == chunk_size
  end
  result
end

puts "Part 1: #{chars_until_unique_chunk(input_chars, 4)}"
puts "Part 2: #{chars_until_unique_chunk(input_chars, 14)}"
