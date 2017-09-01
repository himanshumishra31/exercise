class RepeatAccessorError < StandardError
end
def A(a,instance_reader: true, instance_writer: true, instance_accessor: nil, &blk)
  p a
  if instance_accessor && instance_reader || instance_accessor && instance_writer
    raise RepeatAccessorError.new
  end
  instance_accessor = instance_writer && instance_reader
  p instance_accessor
  p instance_writer
  p instance_reader


end
begin
  A('hello',instance_accessor: true)
rescue StandardError => e
  puts e.message
end
