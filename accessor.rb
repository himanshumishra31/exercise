module Accessor
  def self.included(klass)
    class << klass

      def hello
        puts 2
      end

      def attr_accessor(name)
        instance_eval %{
          def #{name}
             @#{name}
          end

          def #{name}=(val)
            @#{name} = val
          end
        }
      end
    end
  end
end

class My
  include Accessor
  attr_accessor :var
end

a = My.new
My.var = 10
puts My.var
# a.var = 10
# puts a.var
 My.hello
# My.var = 10
# puts My.var
