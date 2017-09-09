class ShoppingList
  attr_reader :list, :total
  def initialize
		@list = Hash.new(0)
		@total = 0
	end

	def add(item, quantity)
		@list[item] += quantity
		@total += quantity
	end

	def items(&block)
		instance_eval(&block)
	end
end

sl = ShoppingList.new
sl.items do
	add("Toothpaste",2)
	add("Computer",1)
  add("Toothpaste",3)
end
puts sl.list
puts sl.total

