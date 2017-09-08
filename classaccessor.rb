class RepeatAccessorError < StandardError ; end
class NameError < StandardError ; end

class Module

  VALID_ATTRIBUTE_REGEX = /\A[_A-Za-z]\w*\z/

  attr_accessor :instance_reader, :instance_writer, :instance_accessor

  def create_accessor_method
    arr = ['reader','writer']
    arr.each do |name|
      self.class.class_eval do
        define_method("cattr_#{name}") do |*syms,instance|
          syms.each do |sym|
            @@sym = sym
            @@method_name = name
            class << self
              instance_eval "#{@@method_name}_method(@@sym)"
            end
            if instance
              instance_eval "#{@@method_name}_method(@@sym)"
            end
          end
        end
      end
    end
  end

  def reader_method(method_name)
    define_method(method_name) { @@sym }
  end


  def writer_method(method_name)
    define_method("#{method_name}=") { |val| @@sym = val }
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
    create_accessor_method
    cattr_reader(*syms,instance_reader)
    cattr_writer(*syms,instance_writer)
  end
end

class Person
  cattr_accessor :hair_colors, instance_writer: true, instance_reader: true
end

class Male < Person
end

begin
  Person.hair_colors = [1,2,3]
  p Person.hair_colors
  p Person.new.hair_colors
  p Male.hair_colors
  Male.hair_colors = ['a','b']
  p Male.hair_colors
  Male.hair_colors << 'c'
  p Person.hair_colors
  p Male.new.hair_colors
end
