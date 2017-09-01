require 'forwardable'
module MyObjectStore
  def self.included(klass)
    class << klass
      extend Forwardable
      attr_accessor :array_object
      def_delegator :@array_object, :collect
      def_delegator :@array_object, :count
      def attr_accesor(*args)
        args.each do |name|
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
    raise "Age not an integer" unless is_age_num? if defined? age
    if defined? validate
      self.class.array_object << self if validate && is_exist?
    else
      self.class.array_object << self if is_exist?
    end
  end

  def is_age_num?
    age.is_a?(Integer)
  end
end

class Play
  @array_object = []
  include MyObjectStore
  include Enumerable
  attr_accesor :fname ,:lname ,:age ,:email
  validate_presence_of :fname, :email

  def validate
    fname.length > 2
  end
end

p2 = Play.new
p2.fname = "abc"
p2.lname = "def"
p2.email = "heloo@gmail.com"
p2.age = 1
begin
p2.save

p3 = Play.new
p3.fname = "bcd"
p3.save

p4 = Play.new
p4.fname ="bc"
p4.save

p4 = Play.new
p4.age ="bc"
p4.fname = "pp"
p4.save

p Play.collect
p Play.count
p Play.find_by_fname('bcd')
p Play.find_by_lname('def')

rescue StandardError => e
  puts e.message
end
