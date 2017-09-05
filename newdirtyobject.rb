module DirtyObject
  @@dirty_hash = Hash.new(Array.new(1))
  @@changed = false
  def self.included(klass)
    class << klass
      def define_dirty_attributes(*args)
        args.each do |param|
          class_eval %{
            def #{param}=(val)
              @@changed = true
              @#{param}=val
              change_hash(val,'#{param}')
            end

            def #{param}
              @#{param}
            end

            def #{param}_was
              return 'nil' unless @@dirty_hash['#{param}'][0]
              @@dirty_hash['#{param}'][0]
            end
          }
        end
      end
    end
  end

  def change_hash(val,param)

    if @@dirty_hash[param][0] == val || @@dirty_hash[param][1] == val
      @@dirty_hash.delete(param)
      @@changed = false if @@dirty_hash.empty?
    else
      @@dirty_hash[param] += [val]
      @@dirty_hash[param].shift if @@dirty_hash[param].length > 2
    end
  end

  def changes
    return {} unless changed?
    @@dirty_hash

  end

  def changed?
    @@changed
  end

  def save
    @@changed = false
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

  puts u.changed? #=> true
  puts u.changes  #=> { name: [nil, 'Akhil], age: [nil, 30] }

  puts u.name_was   #=> nil

  puts u.email_was  rescue puts 'undefined method'
  puts u.age_was    #=> nil

  puts u.save       #=> true


  puts u.changed?   #=> false
  puts u.changes    #=> {}

  u.name = 'New name'
  u.age  = 31
  puts u.changes   #=> {name: ['Akhil', 'New name'], age: [30, 31]}
  puts u.name_was  #=> 'Akhil'

  u.name = 'Akhil'
  puts u.changes   #=> {age: [30, 31]}
  puts u.changed?  #=> true

  u.age = 30
  puts u.changes   #=> {}
  puts u.changed?  #=> false

