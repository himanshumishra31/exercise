class Dynamic < String
	def exclude?(other)
		!include?(other)
	end

	def camelcase
    split.map(&:capitalize).join('')
	end

  def reverse_sentence
    split(' ').reverse.join(' ')
  end
end

puts 'Enter string'
string = gets.chomp
object = Dynamic.new(string)
puts "Methods defined #{ Dynamic.instance_methods(false) }"
puts 'Enter method name to be used'
method_name = gets.chomp
puts object.public_send(method_name)
