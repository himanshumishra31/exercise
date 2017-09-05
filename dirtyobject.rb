require "observer"

module DirtyObject
  @@dirty_object = []
  @@hash = Hash.new([])
  include Observable
  def initialize
    add_observer(self,func=:update)
  end

  def self.included(klass)
    class << klass
      def define_dirty_attributes(*args)
        @@dirty_object << args
      end
    end
  end

  def save
    changed
  end

  def changed?
  end

  def changes
    notify_observers
  end

  def update

  end

  def display_dirty_object
    @@dirty_object
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
puts u.display_dirty_object
# puts u.changed?
# puts u.save
# puts u.changed?
