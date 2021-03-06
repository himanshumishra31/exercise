module DirtyObject
  def initialize
    @dirty_hash = Hash.new(Array.new(1))
    @changed = false
  end

  def self.included(klass)
    class << klass
      def define_dirty_attributes(*args)
        args.each do |param|
          define_method("#{param}=") do |val|
            @param = val
            @changed = true
            change_hash(val,param)
          end

          define_method(param) do
            @param
          end

          define_method("#{param}_was") do
            return 'nil' unless @dirty_hash[param][0]
            @dirty_hash[param][0]
          end
        end
      end
    end
  end

  def change_hash(val, param)
    if @dirty_hash[param][0] == val
      @dirty_hash.delete(param)
      @changed = false if @dirty_hash.empty?
    else
      @dirty_hash[param] += [val]
      @dirty_hash[param].shift if @dirty_hash[param].length > 2
    end
  end

  def changes
    return {} unless changed?
    @dirty_hash
 end

  def changed?
    @changed
  end

  def save
    @changed = false
    @dirty_hash.each { |key,values| values.shift }
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
puts u.name_was
puts u.email_was rescue puts 'undefined method'
puts u.age_was
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
