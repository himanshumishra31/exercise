# Your Ruby code here
class Interactive
  attr_accessor :result
  def initialize
    @result = []
  end
  
  def set_binding
    binding
  end

  def evaluate(bind, input)
    bind.eval(input)
  end

  def check(bind)
    input = gets
    return false if input.chomp.eql? 'q'
    @result << evaluate(bind, input)
    true
  end
end

object = Interactive.new
bind = object.set_binding


more_input = true
while more_input
  begin
    more_input = object.check(bind)
    if more_input
      puts object.result
      object.result = []
    end
  rescue Exception => e
    puts e.message
    more_input = true
  end
end

