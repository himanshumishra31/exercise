module MyObjectStore
  def self.included(klass)
    class << klass
      attr_accessor :array_object, :find_by, :validate
      def count
        array_object.length
      end

      def collect
        array_object
      end

      def validate_presence_of(*args)
        args.each do |name|
          define_method("is_exist_#{name}") do
            return true if eval(name.to_s)
            false
          end
        end
      end
    end
    klass.find_by.each do |name|
      klass.instance_eval %{
        def find_by_#{name}(value)
          array_object.find { |x| x.#{name}.eql? value }
        end
        }
    end
  end

  def save
    validate
    self.class.array_object << self if @errors.empty?
    return "created object #{self}" if @errors.empty?
    @errors
  end

end

class Play
  @find_by = [:fname, :lname, :age, :email]
  @validate = [:fname, :age]
  @array_object = []
  include MyObjectStore
  include Enumerable
  attr_accessor :fname ,:lname ,:age ,:email
  validate_presence_of :fname ,:age


  def initialize
    @errors = Hash.new(Array.new)
  end

  def validate
    @errors[:age] += ['Age should be a integer'] unless age.is_a?(Integer)
    self.class.validate.each do |param|
      @errors[param] += ["#{param} must exist"] unless eval("is_exist_#{param}")
    end
  end
end

p2 = Play.new
p2.fname = "abc"
p2.lname = "def"
p2.email = "heloo@gmail.com"
p2.age = 1

p3 = Play.new
p3.fname = "bsd"
p3.age = 12

p4 = Play.new
p4.fname ="bc"

p5 = Play.new
p5.age ="bc"

puts p2.save
puts p3.save
puts p4.save
puts p5.save

p Play.collect
p Play.count

p Play.find_by_fname('abc')
p Play.find_by_lname('def')
