def read_input
  file = File.open('input')
  input = file.read
end

def sample_input 
#   input = <<EOF
#   2333133121414131402
# EOF
  input = "12345"
end

def parse_input(input)
  input.chars.each_slice(2).with_index.flat_map do |(file_size, free_size), i|
    # puts [file_size.to_i, free_size.to_i, i].inspect
    [{type: :file, file_id: i, length: file_size.to_i}, {type: :free, length: free_size.to_i}]
  end
end

def rearrange(disk_map)
  rearranged_start = []
  rearranged_end = []

  while disk_map.length > 0 do 
    next_block = disk_map.shift

    puts "next: #{next_block}, rest: #{disk_map}"

    case next_block[:type]
    when :file
      rearranged_start.append(next_block)
      rearranged_end.unshift({type: :free, length: next_block[:length]})
    when :free
      last_block = disk_map.pop
      while last_block
        if last_block[:type] == :file
          length_to_move = [last_file[:length], next_block[:length]].min
          rearranged_start.append({
            type: :file,
            file_id: last_file[:file_id],
            length: length_to_move
          })
          rearranged_end.unshift({type: :free, length: length_to_move})

          last_block[:length] -= length_to_move
          next_block[:length] -= length_to_move
        elsif last_block[:type] == :free
          rearranged_start.append({
            type: 
          })  
        end

        last_block = disk_map.pop
      end
    end
  end

  rearranged_start + rearranged_end
end

def disk_map_to_s(disk_map)
  disk_map.map do |block|
    char = case block[:type]
    when :file
      block[:file_id].to_s
    when :free
      '.'
    end

    char * block[:length]
  end.join
end

def part_1
  disk_map = parse_input(sample_input)
  puts disk_map_to_s(disk_map)
  puts disk_map.inspect
  rearranged = rearrange(disk_map)
  puts rearranged.inspect
  disk_map_to_s(rearranged)
end

# def get_last_file_index(disk_map)
#   (1..disk_map.length).each do |i|
#     block = disk_map[-i]
#     if block[:type] == :file && block[:length] > 0
#       return -i
#     end
#   end
  
#   nil
# end

def part_2
end

puts "part 1: #{part_1}"