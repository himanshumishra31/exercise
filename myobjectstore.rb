require 'forwardable'
module MyObjectStore
  def self.included(klass)
    class << klass
      extend Forwardable
      attr_accessor :array_object
      # try to create a method of count and collect instead of using delegator
      def_delegator :@array_object, :collect
      def_delegator :@array_object, :count
      def attr_accesor(*args)
        args.each do |name| # no use of instance or class eval
          # study differnce between class instance variable and class variable
          # study current scope and self

          class_eval %{
            def #{name}
              @#{name}
            end

            def #{name}=(val)
              @#{name} = val
            end
          }

          instance_eval %{
            def find_by_#{name}(value)
              array_object.find { |x| x.#{name}.eql? value }
            end
          }
        end
      end
      # use define_method instead of evals
      def validate_presence_of(*args)
        class_eval %{
          def is_exist?
            #{args}.all? { |x| eval(x.to_s) }
          end
          }
      end
    end
  end

  def save
    # call validate method and store all the errrors in error
    raise "Age not an integer" unless is_age_num? if defined? age
    if defined? validate
      self.class.array_object << self if validate && is_exist?
    else
      self.class.array_object << self if is_exist?
    end
  end

  def is_age_num?
    # don't create this function , instead create an validate_numerical method just like validate_presence_of
    age.is_a?(Integer)
  end
end

class Play
  # create top level variable for find by method
  @array_object = []
  include MyObjectStore
  # create an instance variable of errors which store errors if there are
  # include Enumerable
  # create a top level constant for find by method and make normal attr_accessor methods
  attr_accesor :fname ,:lname ,:age ,:email
  validate_presence_of :fname, :email

  def validate
    # store error in errors variable
    fname.length > 2
  end
end

p2 = Play.new
p2.fname = "abc"
p2.lname = "def"
p2.email = "heloo@gmail.com"
p2.age = 1
p2.save
begin
# p2.save

# p3 = Play.new
# p3.fname = "bcd"
# p3.save

# p4 = Play.new
# p4.fname ="bc"
# p4.save

# p4 = Play.new
# # p4.age ="bc"
# p4.fname = "pp"
# p4.save

p Play.collect
p Play.count
p Play.find_by_fname('bcd')
p Play.find_by_lname('def')

rescue StandardError => e
  puts e.message
end
