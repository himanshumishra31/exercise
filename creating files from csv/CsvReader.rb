class CsvReader
  EXTENSION_REGEX = /(.csv)$/
  INVALID_FILENAME = /\A[A-Z]/
  FILE_WITH_NAME = /\s/
  def initialize(pathname)
    @classname = File.basename(pathname,'.csv')
    raise FileExtensionError, 'The file extension is not valid' unless EXTENSION_REGEX.match?(pathname)
    raise FileNameError, 'File name does not start with uppercase letter' unless INVALID_FILENAME.match?(@classname)
    raise FileNameError, 'File name contains space' if FILE_WITH_NAME.match?(@classname)
  end

  def execute
    @csv_creator_obj = CsvClassCreator.new(@classname)
    @data_array = csv_read
    @csv_creator_obj.create_method_object(@data_array)
    display_values
  end

  def display_values
    @csv_creator_obj.array_object.each do |obj_id|
      @data_array.headers.each do |method_name|
        puts "#{method_name} : #{obj_id.public_send(method_name)}"
      end
      puts "End of entry\n "
    end
    puts 'End of a csv file'
  end

  def csv_read
    CSV.read("#{@classname}.csv", headers: true)
  end
end
