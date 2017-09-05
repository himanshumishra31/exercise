class CsvClassCreator
  def initialize(classname)
    @klass = Class.new do
     @array_object = []
      class << self
        attr_reader :array_object
      end

      define_method :initialize do
        @store_values = {}
        self.class.array_object << self
      end
    end
    Object.const_set(classname, @klass)
  end

  def create_read_values_method
    @klass.class_eval do
      define_method :read_values_from_csv do |*row|
        row.each do |key,value|
          @store_values[key] = value
        end
      end
    end
  end

  def create_method(data_array)
    data_array.headers.each do |method_name|
      @klass.class_eval do
        define_method(method_name) { @store_values[method_name] }
      end
    end
  end

  def array_object
    @klass.array_object
  end

  def create_method_object(data_array)
    create_read_values_method
    data_array.each do |row|
      obj = @klass.new
      obj.read_values_from_csv(*row)
    end
    create_method(data_array)
  end
end
