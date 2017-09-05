class Person
  def initialize
    @a = 1
    @b =2
  end

  def meth
  end
end

p= Person.new
# puts p.methods.grep(/meth/)
puts Person.instance_methods(false)
