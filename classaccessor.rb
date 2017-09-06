class RepeatAccessorError < StandardError
end
class NameError < StandardError
end

class Module

  VALID_ATTRIBUTE_REGEX = /\A[_A-Za-z]\w*\z/

  def cattr_reader(*syms)
    syms.each do |sym|
      @@method_name = "#{sym}"
      class_eval do
        class << self
          define_method(@@method_name) { @@sym }
        end

        define_method(@@method_name) { @@sym }
      end
    end
  end

  def cattr_writer(*syms)
    syms.each do |sym|
      class_eval do
        @@method_name = "#{sym}="
        class << self
          define_method(@@method_name) { |val| @@sym = val }
        end

        define_method(@@method_name) { |val| @@sym = val }
      end
    end
  end

  def cattr_accessor(*syms, instance_reader: nil, instance_writer: nil, instance_accessor: nil)
    set_default_values(syms, instance_reader, instance_writer, instance_accessor)
    cattr_reader(*syms) if @instance_reader || @instance_accessor
    cattr_writer(*syms) if @instance_writer || @instance_accessor
  end

  def set_default_values(syms, instance_reader, instance_writer, instance_accessor)
    raise RepeatAccessorError, 'Access repeated' unless instance_accessor.nil? || (instance_reader.nil? && instance_writer.nil?)
    @instance_reader = true if instance_reader.nil?
    @instance_writer = true if instance_writer.nil?
    @instance_accessor = instance_reader && instance_writer if instance_accessor.nil?
    raise NameError, 'invalid attribute' unless syms.all? { |sym| VALID_ATTRIBUTE_REGEX.match?(sym) }
  end
end

class Person
  begin
  cattr_accessor :hair_colors, instance_writer: true, instance_reader: true
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
