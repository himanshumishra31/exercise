module DirtyObject
  attr_accessor :dirty_hash
  def initialize
    @dirty_hash = Hash.new { |hash, key| hash[key] = [nil,nil] }
    @changed = false
  end

  def self.included(klass)
    class << klass
      def define_dirty_attributes(*args)
        args.each do |param|
          define_method("#{param}=") do |val|
            @param = val
            change_hash(val,param)
          end

          define_method("#{param}") do
            @param
          end

          define_method("#{param}_was") do
            @dirty_hash[param][0] if @dirty_hash[param].length > 1
          end
        end
      end
    end
  end

  def change_hash(val,param)
    if @dirty_hash[param][0] == val
      @dirty_hash[param].pop
    else
      @dirty_hash[param][1] = val
      @changed = true
    end
  end

  def changes
    @dirty_hash.select {|key,value| @dirty_hash[key].length > 1 }
  end

  def changed?
    @changed
  end

  def save
    @dirty_hash.each { |key,value| @dirty_hash[key].shift }
    @changed = false
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
