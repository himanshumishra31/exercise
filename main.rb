require_relative 'CsvReader'
require_relative 'CsvClassCreator'
require 'csv'

class FileNameError < StandardError ; end
class FileExtension < StandardError ; end

begin
  CsvReader.new('/Users/vins/Desktop/advcodes/Person.csv')
  CsvReader.new('/Users/vins/Desktop/advcodes/Student.csv')
rescue StandardError => e
  puts e.message
end
