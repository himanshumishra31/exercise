class CsvClassCreator

  def initialize(classname)
    @klass = Class.new do
     @array_object = []
      def initialize
        @hash = {}
        self.class.array_object << self
      end
      class << self
        attr_reader :array_object
      end
      def read_values_from_csv(*row)
        row.each do |key,value|
          @hash[key] = value
        end
      end
    end
    Object.const_set(classname, @klass)
  end

  def create_method(data_array)
    data_array.headers.each do |method_name|
      @klass.class_eval do
        define_method(method_name) { @hash[method_name] }
      end
    end
  end

  def array_object
    @klass.array_object
  end

  def method_object(data_array)
    data_array.each do |row|
      obj = @klass.new
      obj.read_values_from_csv(*row)
    end
    create_method(data_array)
  end
end
