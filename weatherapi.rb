require 'json'
require 'pry'
require 'HTTParty'
require 'Date'
require 'Time'
require './Event'
require './app.rb'


def fetch_weather(zipcode)
	token = ENV["WEATHER_API_KEY"]
	HTTParty.get("http://api.worldweatheronline.com/premium/v1/weather.ashx?key=#{token}&q=#{zipcode}&tp=1&format=json")
	# data = JSON.parse File.read '.\plannerdata.json'
end

def rain_chance(fetch_data, days, hour)
	fetch_data['data']['weather'][days]['hourly'][hour]['chanceofrain']
end

def max_temp(fetch_data, days)
	fetch_data['data']['weather'][days]['maxtempF']
end

def min_temp(fetch_data, days)
	fetch_data['data']['weather'][days]['mintempF']
end

def hour_temp(fetch_data, days, hour)
	# http://api.worldweatheronline.com/premium/v1/weather.ashx?key=#{token}&q=27703&tp=1&format=json
	fetch_data['data']['weather'][days]['hourly'][hour]['tempF']
end

def date_math(month, day)
	endDate = Date.new(2016,month,day)
	beginDate = DateTime.now
	days = (endDate - beginDate).to_i
end

def display_weather(month, day, hour, zip)

	fetch_data = fetch_weather("zip")
	days = date_math(month, day)
	if date_math(month, day) < 13
		maxtemp = max_temp(fetch_data, days)
		mintemp = min_temp(fetch_data, days)
		hourtemp = hour_temp(fetch_data, days, hour)
		rain = rain_chance(fetch_data, days, hour)
		return "Avg High: #{maxtemp}, Avg Low: #{mintemp}, Temp: #{hourtemp}, Rain Chance: #{rain}"
	else
		return "Can only check weather 2 weeks in advance."
	end
end

# days = date_math(06, 06)
#               month, day
# out_of_calls = JSON.parse File.read 'out_of_calls.json'
# dummy_data = JSON.parse File.read 'plannerdata.json'
# binding.pry
# if fetch_data.to_json == out_of_calls.to_json
# 	puts "Using dummy data, we are out of calls"
# 	fetch_data = dummy_data
# else
# 	puts "Using real data"
# 	fetch_data
# end
