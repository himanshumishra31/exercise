require 'csv'
class CsvClassCreator

  def initialize(classname)
    @klass = Class.new do

      @array_object = []

      def initialize(row)
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

  def get_array_object
    @klass.array_object
  end

  def method_object(data_array)
    data_array.each do |row|
      obj = @klass.new(row)
      obj.read_values_from_csv(*row)
    end
    create_method(data_array)
  end

end

class CsvReader

  def initialize(classname)
    my_obj = CsvClassCreator.new(classname)
    data_array = CSV.read("#{classname}.csv", :headers => true)
    my_obj.method_object(data_array)
    my_obj.get_array_object.each do |x|
      data_array.headers.each do |header|
        puts "#{header} : #{x.send(header)}"
      end
      puts ""
    end
    puts ""
  end
end

path2 = '/Users/vins/Desktop/advcodes/Person.csv'
CsvReader.new(File.basename(path2, '.csv'))

path = '/Users/vins/Desktop/advcodes/Student.csv'
CsvReader.new(File.basename(path, '.csv'))


