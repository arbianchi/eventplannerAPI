require './app.rb'


class Event

	attr_reader :title, :date, :zipcode, :time

	def initialize event
		@title = event["title"]
		@date = event["date"]
		@zipcode = event["zipcode"]
		@time = event["time"]


	end

	def valid?
		#  if event_valid? && description_valid? && location.valid? && time_valid?
		if title_valid? && zipcode_valid? && date_valid?
			true
			#   else
			#       false
			#   end
		end
	end

	def title_valid?
		unless @title == @title.to_i.to_s
			true
		end
	end

	def zipcode_valid?
		unless @zipcode.length != 5 || !(@zipcode !~ /\D/) 
			true
		end
	end

	def date_valid?
		unless @date.length != 4 || !(@date !~ /\D/) 
			true
		end

	end


end
