#!/usr/bin/env ruby
#

require 'rubygems'
require './spot'
require './haver_sin'

class Map
    attr_accessor :spots, :means
    def initialize(spots, means = 3)
        @spots, @means= spots, means
    end

    def seeds_located?
        for i in 1..@means
            if HaverSin.calculate_distance(@seeds[@index][i-1], @seeds[1-@index][i-1]).abs > 0.01
                return false
            end
        end
        return true
    end

    def k_means
        k_means_init
        until seeds_located?
            k_means_group
            p @result
            for i in 1..@result.length
                for j in 1..@result.length
                    if @result[i-1].length > 0 and @result[j-1].length > 0
                        distance = HaverSin.calculate_distance(@spots[@result[i-1][0]], @spots[@result[j-1][0]])
                        print "| %.2f |" % distance
                    else
                        print "|    |"
                    end
                end
                puts ""
            end
            sleep(5)
            k_means_squeeze
        end
        @result
    end

    def k_means_init
        @result = {}
        @seeds = [[], []]
        (1..@means).map do |seed_count|
            random_value = rand(@spots.length)
            @seeds[0] << Spot.new('0', '0')
            @seeds[1] << Spot.new(@spots[random_value].lat, @spots[random_value].lng)
            @result[seed_count-1] = []
        end
        @index = 1
        #p @seeds
    end

    def k_means_group
        @result = {}
        (1..@means).map do |seed_count|
            @result[seed_count-1] = []
        end
        for i in 1..@spots.length
            # group spots by distance
            nearest_distance = 999999999.0
            nearest_seed = 0 
            for j in 1..@means
                distance = HaverSin.calculate_distance(@spots[i-1], @seeds[@index][j-1])
                if distance < nearest_distance
                    nearest_distance = distance
                    nearest_seed = j-1
                end
            end
            @result[nearest_seed] << i-1
        end
    end

    def k_means_squeeze
        # recalculate the seeds
        for i in 1..@means
            if @result[i-1].length == 0
                random_value = rand(@spots.length)
                @seeds[1-@index][i-1] = Spot.new(@spots[random_value].lat, @spots[random_value].lng)
                next
            end
            lat_sum, lng_sum = 0.0, 0.0
            for j in 1..@result[i-1].length
                lat_sum += @spots[@result[i-1][j-1]].lat
                lng_sum += @spots[@result[i-1][j-1]].lng
            end
            @seeds[1-@index][i-1] = Spot.new(lat_sum/@result[i-1].length, lng_sum/ @result[i-1].length)
        end
        @index = 1 - @index
    end
end

spots = []
[
    ['51.522706', '-0.079162'],
    ['51.502719', '0.042897'],
    ['51.529773', '-0.133342'],
    ['51.494061', '-0.279817'],
    ['51.511817', '-0.132619'],
    ['51.515328', '-0.122472'],
    ['51.526404', '-0.200584'],
    ['51.517462', '-0.152971'],
    ['51.508243', '-0.131863'],
    ['51.5474905', '-0.1262809'],
    ['51.510212', '-0.132061'],
    ['51.513437', '-0.1308'],
    ['51.512921', '-0.122198'],
    ['51.503313', '-0.148512'],
    ['54.808467', '-3.107924'],
    ['51.508929', '-0.128299'],
    ['51.507821', '-0.07795'],
    ['51.508355', '-0.124807'],
    ['51.63272', '-0.173421'],
    ['51.513642', '-0.126793'],
    ['51.508582', '-0.198717'],
    ['51.511735', '-0.11747'],
    ['51.499167', '-0.124722'],
    ['51.501961', '-0.129191'],
    ['51.496639', '-0.17218'],
    ['51.50246', '-0.134811'],
    ['51.511363', '-0.182117'],
    ['51.500729', '-0.124625'],
    ['51.496641', '-0.142474'],
    ['51.597844', '-0.238091'],
].each do |lat_and_lng|
    spots << Spot.new(lat_and_lng[0], lat_and_lng[1])
end

map = Map.new(spots, 3*2)
map.k_means
