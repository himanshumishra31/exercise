
begin
	cricket = "cricket"
	def cricket.has_wickets?
		"yes"
	end

	football = "football"
	class << football
		def goal?
			"yes"
		end
	end
	puts football.goal?
	puts cricket.has_wickets?
	raise cricket.goal?
	rescue Exception => e
	puts e.message
end
