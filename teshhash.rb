# a = Hash.new { |hash, key| hash[key] = [] }
a = Hash.new([])
a[:a] << [1]
# puts a
a[:b] = [2]
# # puts a
a[:c]
# a[:d] = [3]
puts a
puts a[:a].object_id
puts a[:b].object_id
puts a[:c].object_id
puts a[:d].object_id
