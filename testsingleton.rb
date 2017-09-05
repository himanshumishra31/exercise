module MyObjectStore
  def self.included(klass)
    class << klass
      attr_accessor :array_object, :find_by, :validate, :validators
      def count
        array_object.length
      end

      def collect
        array_object
      end

      def validate_presence_of(*args)
        @validate = args # no need of this
        args.each do |name|
          @validators << "is_exist_#{name}"
          # puts all methods in validators
          define_method("is_exist_#{name}") do
            return true if public_send(name.to_s)
            false
          end
        end
      end
    end

    klass.singleton_class.class_eval do
      klass::FIND_BY.each do |param|
        define_method("find_by_#{param}") do |value|
          array_object.find_all { |x| x.public_send(param).eql? value}
        end
      end
    end
  end

  def save
    validate
    if @errors.empty?
      self.class.array_object << self
      "created object #{self}"
    else
      @errors
    end
  end

end

class Play
  FIND_BY = [:fname, :lname, :age, :email]
  @array_object = []
  @validators = []
  # create a validator and puts all the validators
  include MyObjectStore

  attr_accessor :fname ,:lname ,:age ,:email
  validate_presence_of :fname ,:age
  # validate_numerical_of

  def initialize
    @errors = Hash.new(Array.new)
    #use diff syntax
    # study difference between both syntax
    # study instance eval class eval self, singleton class
  end

  def validate
    # call all functions in validators and it will set the errors
    # here only validators will be called
    # @errors[:age] += ['Age should be a integer'] unless age.is_a?(Integer)
    self.class.validate.each do |param|
      @errors[param] += ["#{param} must exist"] unless eval("is_exist_#{param}")
    end
  end
end

p2 = Play.new
p2.fname = "abc"
p2.lname = "def"
p2.email = "heloo@gmail.com"
# puts p2.save
p2.age = 1
puts p2.save
# puts Play.validators
# p3 = Play.new
# p3.fname = "bsd"
# p3.age = 12

# p4 = Play.new
# p4.fname ="bc"

# p5 = Play.new
# p5.age ="bc"

# puts p2.save
# puts p3.save
# puts p4.save
# puts p5.save

# p Play.collect
# p Play.count

p Play.find_by_fname('abc')
p Play.find_by_lname('def')
