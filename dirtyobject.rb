require "observer"

module Observable
  def changed?
    if defined? @observer_state and @observer_state
      false
    else
      true
    end
  end
end


module DirtyObject
  include Observable
  def initialize
    add_observer(self,func=:update)
  end

  def self.included(klass)
    class << klass
      def define_dirty_attributes(*args)
        puts args.inspect
      end
    end
  end

  def save
    changed
  end

  def changes
    notify_observers
  end

  def update

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
puts u.save
puts u.changed?
# puts u.save
# puts u.changed?
# puts u.changes
