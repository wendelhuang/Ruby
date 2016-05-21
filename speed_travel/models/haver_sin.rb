#!/usr/bin/env ruby

include Math

class HaverSin
    def self.EARTH_RADIUS
        6378.137
    end
    def self.haver_sin(thera)
        Math.sin(thera/2) * Math.sin(thera/2)
    end
    def self.degrees_to_radians(degrees)
        degrees * Math::PI / 180
    end
    def self.radians_to_degrees(radians)
        radians * 180.0 / Math::PI
    end
    def self.calculate_distance(spot_a, spot_b)
        spot_a_lat_radians = degrees_to_radians(spot_a.lat)
        spot_a_lng_radians = degrees_to_radians(spot_a.lng)
        spot_b_lat_radians = degrees_to_radians(spot_b.lat)
        spot_b_lng_radians = degrees_to_radians(spot_b.lng)

        diff_lat = (spot_a_lat_radians - spot_b_lat_radians).abs
        diff_lng = (spot_a_lng_radians - spot_b_lng_radians).abs

        h = haver_sin(diff_lat) + Math.cos(spot_a_lat_radians) * Math.cos(spot_b_lat_radians) * haver_sin(diff_lng)
        2 * Math.asin(Math.sqrt(h)) * self.EARTH_RADIUS
    end
end
