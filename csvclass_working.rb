require 'csv'
#class CSV_class_creator
pn = "/Users/vins/Desktop/advcodes/Person.csv"
classname = File.basename(pn,'.csv')
data_array = CSV.read('Person.csv', :headers => true) 
cls = Class.new do
	@@array_objects = []
	
	def initialize(*values)
		@hash = {}
		display(*values)
	    @@array_objects << self
	end

	def display(*values)
		values.each do |key,value|
			@hash[key] = value
		end
	end

	def self.objects
	  @@array_objects
	end

	def self.create_method(data_array)
	  data_array.headers.each do |method_name|
		define_method(method_name) do
	    	@hash[method_name]
	   	 end
      end
    end

end

Object.const_set(classname,cls)
cls.create_method(data_array)
row = []
 data_array.each do |row|
 	cls.new(*row)
 end
 object_array = cls.objects
 object_array.each do |x|
 	data_array.headers.each do |header|
      puts "#{header} : #{x.send(header)}"
    end
 end