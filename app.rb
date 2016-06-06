#curl http://localhost:4567/calendar -H "AUTHORIZATION: arb"
#curl -X POST -d'{"title": "another event","date":"04044444","time":"13:45","zipcode":"06405"}' http://localhost:4567/calendar -H "AUTHORIZATION: arb"
#curl -X DELETE -d '{"title":"new"}' http://localhost:4567/calendar -H "AUTHORIZATION: arb"
#curl -X POST -d'{"title": "another event","date":"04044444","time":"13:45","zipcode":"06405"}' http://tiy-event-planner.herokuapp.com/calendar -H "AUTHORIZATION: arb"
#curl -X DELETE -d '{"title":"new"}' http://tiy-event-planner.herokuapp.com/calendar -H "AUTHORIZATION: arb"

require 'sinatra/base'
require 'httparty'
require 'sinatra/json'
require 'json'
require './Event.rb'
require 'pry'
require './weatherapi.rb'

class EventPlannerApp < Sinatra::Base
  set :logging, true
  set :show_exceptions, false
  error do |e|
    raise e
  end

  DB = {}

  before do
    require_authorization!
  end

  def require_authorization!
    unless username
      status 401
      halt({ error: "You must log in" }.to_json)
    end
  end

  def username
    request.env["HTTP_AUTHORIZATION"]
  end

  def print_calendar
    array = []
    DB[username].each do |event|
      array.push event.title
    end
    return array
  end


  get "/calendar" do
    DB[username] ||= []
    calendar = print_calendar
    json calendar
  end

  get "/calendar/:title" do
    DB[username] ||= []
    title = params['title']

    if title
      event = DB[username].find { |i| i.title == title}
      date = event.date.split("").map(&:to_i)
      month = event.date[0,2].to_i
      day = event.date[2..3].to_i
      hour = (event.time.to_i).round(-2) #so 13:45 becomes 13 - 1 = 12, must use military time (1-24). ARB: to_i-1 makes 13:45 into 13:44. Just gonna prompt the user for military time for now
      weather = display_weather(month,day,hour,event.zipcode)
      status 200
      body "Event: #{event.title}, Time: #{event.time}, Zipcode: #{event.zipcode}, WEATHER: #{weather}. Have a great event!"
    else
      status 404
    end

  end


  post "/calendar" do
    body = request.body.read

    begin
      event = Event.new(JSON.parse body)
    rescue
      status 400
      halt "Can't parse json: '#{body}'"
    end
    if event.valid?
      DB[username] ||= []
      DB[username].push event
      status 200
      body "Calendar updated with: #{event.title} at #{event.time} on #{event.date} at #{event.zipcode}\n"
    else
      status 422
      body "Event not valid"

    end
  end

  delete "/calendar" do
    title = request.body.read
    DB[username] ||= []
    existing_item = DB[username].find { |i| i.title == title}

    if existing_item
      DB[username].delete existing_item
      status 200
      body "#{title} deleted!"
    else
      status 404
    end
  end

end


if $PROGRAM_NAME == __FILE__
  EventPlannerApp.run!
end
