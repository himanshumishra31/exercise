require 'Forwardable'
class Foo
  extend Forwardable
  CONSTANT_ARRAY = [0,1,2,3]
  @@class_array  = [4,5,6,7]

  def initialize
    @instance_array = [8,9,10,11]
  end
  delegate :sum, to: :CONSTANT_ARRAY
  delegate :min, to: :@@class_array
  delegate :max, to: :@instance_array
end

puts Foo.new.sum # => 6
puts Foo.new.min # => 4
puts Foo.new.max # => 11
