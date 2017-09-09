class Calculator
  attr_accessor :operator
  def initialize(operator)
    case operator
      when ':+' then @operator = :+
      when ':-' then @operator = :-
      when ':*' then @operator = :*
      when ':/' then @operator = :/
    end
  end
end
input = ARGV[0].tr('"', '').split(',')
object = Calculator.new(input[1])
puts input[0].to_i.send(object.operator,input[2].to_i)
