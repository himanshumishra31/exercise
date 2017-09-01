require "observer"

module Dirty
  include Observable

  def initialize
    add_observer(self)
  end

  def self.included(klass)
    class << klass
      def define_dirty_attributes(*args)
        args.each do |param|
          class_eval %{
            def #{param}=(val)
              changed
            end
          }
        end
      end
    end
  end

  def save
    changes
    puts self
    notify_observers(age)
  end

  def changes
    changed
  end

  def update(num)
    puts num
  end
end

class User
  include Dirty
  attr_accessor :name, :age, :email
  define_dirty_attributes :name, :age
end

u = User.new
u.name = 'Akhil'
u.email = 'akhil@vinsol.com'
u.age = 30
puts 1
puts u.changed?
puts 2
puts u.save
puts 3
puts u.changed?
puts 4
u.name = 'himanshu'
puts 5
puts u.changed?
puts 6
