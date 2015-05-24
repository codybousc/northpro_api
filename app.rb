require('sinatra')
require('sinatra/reloader')
require('./lib/weather')
also_reload('lib/**/*.rb')
require('pg')
require('open-uri')
require('json')
require('pry')


get ('/') do
#@name = params.fetch("name").gsub!(/^\"|\"?$/, '')
 erb(:index)
end


 post ('/results') do

  @name = params.fetch("name").tr(" ", "_")
  weather = open("http://api.wunderground.com/api/92245eaf89618deb/almanac/q/CA/#{@name}.json")
  #erb(:index)
#end

  # #get ('/results') do
  #   @name = params.fetch("name")
  #   weather = open("http://api.wunderground.com/api/92245eaf89618deb/almanac/q/CA/#{@name}.json")

    doc = ""

    weather.each do |line|
      doc << line
    end
    weather.close

    parsed = JSON.parse(doc)

    #Average high
     closer = parsed["almanac"]
     temp_high_full_hash = closer["temp_high"]
     temp_high_fnc = temp_high_full_hash["normal"]
     @avg_high = temp_high_fnc["F"]

     #Record low
     closer = parsed["almanac"]
     temp_low_full_hash = closer["temp_low"]
     temp_low_fnc = temp_low_full_hash["record"]
     @rec_low = temp_low_fnc["F"]

    erb(:results)
  end
