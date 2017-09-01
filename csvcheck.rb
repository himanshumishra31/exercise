require 'csv'
class CsvClassCreator
  #@array_objects = []
  #attr_accessor :array_objects

  def initialize(classname)

    @klass = Class.new do
      @array_object = []

      def initialize
        @hash = {}
        read_values_from_csv
        self.class.array_object << self
      end

      class << self
        attr_accessor :array_object
      end
    end
    Object.const_set(classname, @klass)
  end

  def create_read_method(*row)
    @klass.class_eval do
      #puts row
      define_method :read_values_from_csv do
        row.each do |key,value|
          print key,value
          puts ""
          @hash[key] = value
        end
      end
    end
  end

    def self.display
     @klass.array_object
    end

  def array_objects(*row)
    create_read_method(*row)
    @klass.new
  end

  def create_method(data_array)
    data_array.headers.each do |method_name|
      @klass.class_eval do
        define_method(method_name) { @hash[method_name] }
      end
    end
  end
end

path = '/Users/vins/Desktop/advcodes/Student.csv'
classname = File.basename(path, '.csv')
csv_class_obj = CsvClassCreator.new(classname)

 # path2 = '/Users/vins/Desktop/advcodes/Person.csv'
 # classname2 = File.basename(path2, '.csv')
 # csv_class_obj2 = CsvClassCreator.new(classname2)

data_array = CSV.read('Student.csv', :headers => true)

# data_array2 = CSV.read('Person.csv', :headers => true)

csv_class_obj.create_method(data_array)

# csv_class_obj2.create_method(data_array2)

 data_array.each do |row|
    p row
   csv_class_obj.array_objects(*row)
 end

 # data_array2.each do |row|
 #   csv_class_obj2.array_objects(*row)
 # end



object_array = CsvClassCreator.display

#object_array = csv_class_obj.array_objects
puts object_array
#  object_array.each do |x|
#    data_array.headers.each do |header|
#      puts "#{header} : #{x.send(header)}"
#    end
#  end
