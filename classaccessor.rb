class RepeatAccessorError < StandardError
end

class Module

  def cattr_reader(*syms, instance_reader: true, instance_accessor: nil)
    syms.each do |sym|
      raise NameError.new("invalid attribute name: #{sym}") unless /\A[_A-Za-z]\w*\z/.match?(sym)
      if instance_reader || instance_accessor
        class_eval %{
          @@#{sym} = nil unless defined? @@#{sym}
          def self.#{sym}
            @@#{sym}
          end
          def #{sym}
            @@#{sym}
          end
        }
      end
    end
  end

  def cattr_writer(*syms, instance_writer: true, instance_accessor: nil)
    syms.each do |sym|
      raise NameError.new("invalid attribute name: #{sym}") unless /\A[_A-Za-z]\w*\z/.match?(sym)

      if instance_writer || instance_accessor
        class_eval %{
          @@#{sym} = nil unless defined? @@#{sym}
          def self.#{sym}=(obj)
            @@#{sym} = obj
          end
          def #{sym}=(obj)
            @@#{sym} = obj
          end
        }
      end
    end
  end

  def cattr_accessor(*syms, instance_reader: true, instance_writer: true, instance_accessor: nil, &blk)
    if instance_accessor && instance_reader || instance_accessor && instance_writer
      raise RepeatAccessorError.new
    end
    instance_accessor = instance_reader && instance_writer
    cattr_reader(*syms, instance_reader: instance_reader, instance_accessor: instance_accessor, &blk)
    cattr_writer(*syms, instance_writer: instance_writer, instance_accessor: instance_accessor)
  end

end

class Person
  begin
    cattr_accessor :hair_colors, instance_reader: true , instance_writer: true
end

class Male < Person
end

Person.hair_colors = [1,2,3]
p Person.hair_colors

p Person.new.hair_colors
p Male.hair_colors
Male.hair_colors = ['a','b']
p Male.hair_colors
Male.hair_colors << 'c'
p Person.hair_colors
p Male.new.hair_colors
rescue StandardError => e
  puts e.message
end
