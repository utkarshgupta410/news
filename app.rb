require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "YOUR-API-KEY"

get "/" do
  # show a view that asks for the location
  view "ask"
end

get "/newspaper" do
  
  
#Geolocation:
  results = Geocoder.search(params["location"])
  @location = params["location"]
  lat_lng = results.first.coordinates
  @lat = lat_lng[0]
  @lng = lat_lng[1]

#Weather: 
  ForecastIO.api_key = "ce3af6469e281682efbcc88d15afa7ff" 
  
  @forecast = ForecastIO.forecast(@lat,@lng).to_hash

  @current_temp = @forecast["currently"]["temperature"]
  @current_sum = @forecast["currently"]["summary"]

  @forecastarray = @forecast["daily"]["data"]
  @dailytemparray = []
  @dailysumarray = []

#   for weather_on_day in @forecastarray
#     @dailytemparray << weather_on_day["temperatureHigh"]
#     @dailysumarray << weather_on_day["summary"]
#   end
  
#News:
  url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=1fb4347a5ae64c02bcd3747b6d05de77"
  @news = HTTParty.get(url).parsed_response.to_hash
  
  @newsarray = @news["articles"]
  @topheadlinearray = []
  @urlarray = []

  for articlenumber in @newsarray
    @topheadlinearray << articlenumber["title"]
    @urlarray << articlenumber["url"]
  end
 
  puts @topheadlinearray
  puts @urlarray
  view "newspaper"

end
