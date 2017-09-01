require 'observer'

# A module which redefines attr_writer for classes that include it.
# The direct use of @observer_peers (the list of observers) is a bit
# inelegant, but I didn't want to keep adding the object watcher to
# the array over and over.

module AttrWriterInterceptor
   def self.included(m)
     m.class_eval do
       include Observable
       def self.attr_writer(*attrs)
         attrs.each do |att|
           define_method("#{att}=") do |value|
             @observer_peers ||= []
             unless @observer_peers.include?(ObjectWatcher.instance)
               add_observer(ObjectWatcher.instance)
             end
             instance_variable_set("@#{att}", value)
             changed
             notify_observers(self)
           end
         end
       end
     end
   end
end

# A class that uses the observable attr_writers
class Item
   include AttrWriterInterceptor
   attr_writer :description
   attr_accessor :description
end

a= Item.new
puts a.changed?

puts a.description = "hi"
puts a.changed?

puts a.description = "hello"

puts a.changed?
