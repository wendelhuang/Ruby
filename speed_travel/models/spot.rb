#!/usr/bin/env ruby
#

class Spot
    # 经度 Longitude 简写Lng 纬度 Latitude 简写Lat
    attr_accessor :lat, :lng
    def initialize(lat, lng)
        @lat, @lng = lat.to_f, lng.to_f
    end
end 
