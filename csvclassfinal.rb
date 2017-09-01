require 'csv'
class CSV_class_creator
  def initialize
    #@hash = {}
    #@@array_objects = []
    @klass = Class.new { @@array_objects = []}
    pn = "/Users/vins/Desktop/advcodes/Person.csv"
    classname = File.basename(pn,'.csv')
    Object.const_set(classname,@klass)
    #set_values_from_csv(*values)
    #@@array_objects << self
  end

  def set_values_from_csv(*values)
    values.each do |key,value|
      @hash[key] = value
   end
  end

  def self.objects
    @klass << self
    def array_objects
      @@array_objects
    end
  end

    def self.create_method(data_array)
      data_array.headers.each do |method_name|
      define_method(method_name) do
        @hash[method_name]
         end
        end
      end
     end
end

CSV_class_creator.new
data_array = CSV.read('Person.csv', :headers => true)
Person.create_method(data_array)
data_array.each do |row|
  Person.new(*row)
end
object_array = Person.objects
object_array.each do |x|
  data_array.headers.each do |header|
    puts "#{header} : #{x.send(header)}"
  end
end
