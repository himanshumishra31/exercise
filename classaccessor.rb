class RepeatAccessorError < StandardError
end
class NameError < StandardError
end

class Module

  VALID_ATTRIBUTE_REGEX = /\A[_A-Za-z]\w*\z/

  attr_accessor :instance_reader, :instance_writer, :instance_accessor

  def cattr_reader(*syms)
    syms.each do |sym|
      @@method_name = "#{sym}"
      class_eval do
        class << self
          read_method(@@method_name)
        end
        if instance_reader
          read_method(@@method_name)
        end
      end
    end
  end

  def read_method(method_name)
    define_method(method_name) { @@sym }
  end

  def cattr_writer(*syms)
    syms.each do |sym|
      class_eval do
        @@method_name = "#{sym}="
        class << self
          write_method(@@method_name)
        end
        if instance_writer
          write_method(@@method_name)
        end
      end
    end
  end

  def write_method(method_name)
    define_method(method_name) { |val| @@sym = val }
  end

  def set_accessors(syms)
    repeat_accessor_check
    set_default_values
    attribute_validity(syms)
  end

  def repeat_accessor_check
    raise RepeatAccessorError, 'Accessor repeated' unless instance_accessor.nil? || (instance_reader.nil? && instance_writer.nil?)
  end

  def set_default_values
    instance_reader = true if instance_reader.nil?
    instance_writer = true if instance_writer.nil?
    instance_accessor = instance_reader && instance_writer if instance_accessor.nil?
  end

  def attribute_validity(syms)
    raise NameError, 'invalid attribute' unless syms.all? { |sym| VALID_ATTRIBUTE_REGEX.match?(sym) }
  end

  def cattr_accessor(*syms, instance_reader: nil, instance_writer: nil, instance_accessor: nil)
    self.instance_reader = instance_reader
    self.instance_writer = instance_writer
    self.instance_accessor = instance_accessor
    set_accessors(syms)
    cattr_reader(*syms, instance_reader)
    cattr_writer(*syms, instance_writer)
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
