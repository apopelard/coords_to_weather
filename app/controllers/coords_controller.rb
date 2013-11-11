require 'open-uri'
require 'json'

class CoordsController < ApplicationController
  def fetch_weather
    #address to coord
    @address = "800 elgin road evanston"
    if params["address"] != nil
      @address = params["address"]
    end
    @url_safe_address = URI.encode(@address)
    url = "http://maps.googleapis.com/maps/api/geocode/json?address=#{@url_safe_address}&sensor=false"
    raw_data = open(url).read
    parsed_data = JSON.parse(raw_data)
    @latitude = parsed_data["results"][0]["geometry"]["location"]["lat"]
    @longitude = parsed_data["results"][0]["geometry"]["location"]["lng"]

    #coord to weather
    your_api_key = "ced305631f2849ef2fb612fdf95f6bf1"
    url = "https://api.forecast.io/forecast/#{your_api_key}/#{@latitude},#{@longitude}"
    raw_data = open(url).read
    parsed_data = JSON.parse(raw_data)

    if parsed_data.has_key?("currently")
      @temperature = parsed_data["currently"]["temperature"]
    else
      @temperature = "sorry there is no data available"
    end

    if parsed_data.has_key?("minutely")
      @minutely_summary = parsed_data["minutely"]["summary"]
    else
      @minutely_summary = "sorry there is no data available"
    end

    if parsed_data.has_key?("hourly")
      @hourly_summary = parsed_data["hourly"]["summary"]
    else
      @hourly_summary = "sorry there is no data available"
    end

    if parsed_data.has_key?("daily")
      @daily_summary = parsed_data["daily"]["summary"]
    else
      @daily_summary = "sorry there is no data available"
    end
  end
end
