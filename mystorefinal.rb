module MyObjectStore
  def self.included(klass)
    class << klass
      attr_accessor :saved_objects, :validators
      def count
        saved_objects.length
      end

      def collect
        saved_objects
      end

      def validate_presence_of(*args)
        args.each do |name|
          @validators << "check_presence_of_#{ name }"
          define_method("check_presence_of_#{ name }") do
            @errors["#{ name }"] << ["#{ name } must exist"] unless public_send(name)
          end
        end
      end

      def validate_numericality_of(*args)
        args.each do |name|
          @validators << "numericalilty_of_#{ name }"
          define_method("numericalilty_of_#{ name }") do
            if public_send(name)
              @errors["#{ name }"] << ['must be an integer'] unless public_send(name).is_a?(Integer)
            end
          end
        end
      end
    end

    klass.singleton_class.class_eval do
      klass::DYNAMIC_FIND_BY.each do |param|
        define_method("find_by_#{ param }") do |value|
          saved_objects.find_all { |object| object.public_send(param).eql? value }
        end
      end
    end
  end

  def save
    @errors.clear
    validate
    check_errors_and_save
  end

  def check_errors_and_save
    if @errors.empty?
      self.class.saved_objects << self
      "created object #{ self.inspect }"
    else
      @errors
    end
  end
end

class Play
  DYNAMIC_FIND_BY = [:fname, :lname, :age, :email]
  @saved_objects = []
  @validators = []
  include MyObjectStore
  attr_accessor :fname ,:lname ,:age ,:email
  validate_presence_of :fname, :age
  validate_numericality_of :age

  def initialize
    @errors = Hash.new { |hash, key| hash[key] = [] }
  end

  def validate
    self.class.validators.each do |method_name|
      public_send(method_name)
    end
  end
end

p2 = Play.new
p2.fname = 'abc'
p2.lname = 'def'
p2.email = 'heloo@gmail.com'
p2.age = 1
puts p2.save

p3 = Play.new
p3.fname = 'himanshu'
p3.lname = 'mishra'
p3.email = 'heloooo@gmail.com'
p3.age = 1
puts p3.save

p Play.collect
p Play.count

Play.find_by_fname('xyz')
