module DirtyObject
  attr_accessor :dirty_hash,:name_was, :age_was
  def initialize
    @dirty_hash = Hash.new { |hash, key| hash[key] = [] }
  end

  def self.included(klass)
    class << klass
      def define_dirty_attributes(*args)
        args.each do |param|
          instance_eval("@#{param}_was = nil")
          define_method("#{param}=") do |val|
            instance_eval("@#{param} = val")
            change_hash(val,param)
          end

          define_method("#{param}") do
            instance_eval("@#{param}")
          end

          define_method("#{param}_change") do
            instance_eval("@#{param}_was = @#{param}")
          end
        end
      end
    end
  end

  def change_hash(val,param)
    check = instance_eval("#{param}_was")
    if val.eql? check
      @dirty_hash.delete(param)
    else
      @dirty_hash[param].push(check,val)
    end
  end

  def changes
    @dirty_hash
  end

  def changed?
    @dirty_hash.any?
  end

  def save
    @dirty_hash.each { |key ,_values| instance_eval("#{key}_change") }
    @dirty_hash.clear
    true
  end

end

class User
  include DirtyObject
  attr_accessor :name, :age, :email
  define_dirty_attributes :name, :age
end

u = User.new
u.name  = 'Akhil'
u.email = 'akhil@vinsol.com'
u.age   = 30
puts u.changed?
puts u.changes
puts u.name_was ? u.name_was : 'nil'
puts u.email_was rescue puts 'undefined method'
puts u.age_was ? u.age_was : 'nil'
puts u.save

puts u.changed?
puts u.changes
u.name = 'New name'
u.age  = 31
puts u.changes
puts u.name_was
u.name = 'Akhil'
puts u.changes
puts u.changed?
u.age = 30
puts u.changes
puts u.changed?
