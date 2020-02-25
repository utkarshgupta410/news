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
  # do everything else
  
  results = Geocoder.search(params["location"])
  @location = params["location"]
  lat_lng = results.first.coordinates
  @lat = lat_lng[0]
  @lng = lat_lng[1]
  
  ForecastIO.api_key = "ce3af6469e281682efbcc88d15afa7ff" 
  
  @forecast = ForecastIO.forecast(@lat,@lng).to_hash

  @current_temp = @forecast["currently"]["temperature"]
  @current_sum = @forecast["currently"]["summary"]

  @forecastarray = @forecast["daily"]["data"]
  @dailytemparray = []
  @dailysumarray = []

  for weather_on_day in @forecastarray
    @dailytemparray << weather_on_day["temperatureHigh"]
    @dailysumarray << weather_on_day["summary"]
  end
  


  puts @forecast
  puts @current_temp
  puts @current_sum
  puts @dailytemparray
  puts @dailysumarray


  view "newspaper"

end
