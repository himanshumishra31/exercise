# DynamicClass creates class dynamically
class DynamicClass
  def initialize(class_name)
    @klass = Class.new {}
    Object.const_set(class_name, @klass)
  end

  def def_method(method_name, method_body)
    @klass.class_eval do
      define_method(method_name) { instance_eval(method_body) }
    end
  end

  def call(method_name)
    @klass.new.public_send(method_name)
  end
end

puts 'Please enter the class name:'
class_name = gets.chomp
my_class = DynamicClass.new(class_name)
puts 'Please enter the method name you wish to define:'
method_name = gets.chomp
puts 'Please enter the method\'s code:'
method_body = gets.chomp
my_class.def_method(method_name, method_body)
puts '--- Result ---'
print "Hello, Your class #{ class_name } with method #{ method_name } is ready. Calling:"
puts "#{ class_name }.new.#{ method_name }"
puts my_class.call(method_name)
