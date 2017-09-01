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
            #{args}.all? do |x|
                raise "validate_presence_of condition not satisfied" unless eval(x.to_s)
                true
            end
          end
          }
      end
    end
  end

  def save
    if is_age_num?
      if defined? validate
        self.class.array_object << self if validate && is_exist?
      else
        self.class.array_object << self if is_exist?
      end
    else
      raise "age not a integer in #{self}"
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
  validate_presence_of :fname ,:email

  def validate
    raise "Validate condition not satisfied #{self}" unless fname.length > 2
    true

  end
end

p2 = Play.new
p2.fname = "abc"
p2.lname = "def"
p2.email = "heloo@gmail.com"
p2.age = 1

p3 = Play.new
p3.fname = "bsd"
p3.age = 2

p4 = Play.new
p4.fname ="bc"

p5 = Play.new
p5.age ="bc"
p5.fname = "pp"

begin
  p2.save
  p3.save
  p4.save
  p5.save

  p Play.collect
  p Play.count
  p Play.find_by_fname('bcd')
  p Play.find_by_lname('def')

rescue StandardError => e
  puts e.message
  p Play.collect
  p Play.count
end
