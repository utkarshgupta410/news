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
  lat_lng = results.first.coordinates
  lat = lat_lng[0]
  lng = lat_lng[1]
end