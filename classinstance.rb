class ClassCreator
  def initialize(classname)
    @klass = Class.new do
      @array_object = []
      def initialize
        self.class.array_object << self
      end

      class << self
        attr_accessor :array_object
      end
    end
    Object.const_set(classname,@klass)
  end

  def display
    @klass.new
    @klass.array_object
  end


end


my_class = ClassCreator.new('Himanshu')
my_class1 = ClassCreator.new('Kanojia')
puts my_class.display
puts my_class1.display
# Himanshu.new
# Himanshu.new
# Himanshu.new
# Himanshu.new
# puts Himanshu.array_object
