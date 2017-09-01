module M
  @@array_object = []
   def self.included(klass)
      class << klass
        def disp
          @@array_object
        end
      end
   end

  def save
    @@array_object << self
  end



end

class Ab
include M
end

puts Ab.instance_variables
#Ab.global = 10
Ab.new.save
puts Ab.disp
