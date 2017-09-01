class Dynamic < String
	def initialize(name)
		super
	end

	def exclude?(other)
		!include?(other)
	end

	def concat
  	puts 'Enter optional arguments'
    args = gets.chomp
    param = args.split(&:to_s)
		super(param.join(' '))
	end

  def char_at
    puts 'Enter position(required)'
    pos = gets.chomp
    puts 'Enter replace char'
    chr = gets.chomp
    self[pos.to_i] = chr
    self
  end

  def prepend
    puts 'Enter required string'
    req_arg = gets.chomp
    puts 'Enter optional strings'
    opt_arg = gets
    param = opt_arg.split(&:to_s)
    super(req_arg,param.join(' '))
  end
end

puts 'Enter string'
string = gets.chomp
object = Dynamic.new(string)
puts "Methods defined #{ Dynamic.instance_methods(false) }"
puts 'Enter method name to be used'
method_name = gets.chomp
puts object.public_send(method_name)
