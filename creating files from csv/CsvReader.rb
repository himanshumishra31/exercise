class CsvReader
  def initialize(pathname)
    classname = File.basename(pathname, '.csv')
    check(pathname, classname)
    my_obj = class_object(classname)
    data_array = csv_read(classname)
    my_obj.method_object(data_array)
    my_obj.array_object.each do |x|
      data_array.headers.each do |header|
        puts "#{header} : #{x.send(header)}"
      end
      puts "End of entry\n "
    end
    puts 'End of a csv file'
  end

  def class_object(classname)
    CsvClassCreator.new(classname)
  end

  def csv_read(classname)
    CSV.read("#{classname}.csv", :headers => true)
  end

  def check(pathname, classname)
    raise FileExtensionError.new unless pathname.match?(/.csv/)
    raise FileNameError.new unless classname.match?(/\A[A-Z]/)
    raise FileNameError.new if classname.match?(/\s/)
  end
end
