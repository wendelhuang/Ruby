#!/usr/bin/env ruby
#
require 'net/http'
require 'json'
require 'ostruct'

#url = 'http://101.200.215.178:8111/index.php'
#response = Net::HTTP.get_response(URI(url))
#data = response.body
data = File.read('output/data.txt')
result = JSON.parse(data)
result.each do |key, value|
    puts "['#{value['lat']}', '#{value['lgt']}'],"
end
#p result.length

def build_stay_time_range(min_time, max_time)
    #puts "start_time = #{start_time}, end_time = #{end_time}"
    {min_time: min_time, max_time: max_time}
end
def format_stay_time(stay_time, default_stay_time = 2)
    if stay_time.nil? or stay_time == ''
        return build_stay_time_range(default_stay_time, default_stay_time)
    elsif stay_time.downcase =~ /([0-9]+)-([0-9]+)\shour.*/
        return build_stay_time_range($1.to_i, $2.to_i)
    elsif stay_time.downcase =~ /<([0-9]+)\shour.*/
        return build_stay_time_range(1, $1.to_i)
    elsif stay_time.downcase =~ /more\sthan\s([0-9]+)\shour.*/
        return build_stay_time_range($1.to_i, 24)
    end
    return build_stay_time_range(default_stay_time, default_stay_time)
end
def extract(data)
    data.map do |key, value|
        element = OpenStruct.new
        element.id = key.to_i
        element.name = value['name']
        element.stay_time = format_stay_time(value['stay_time'])
        element.rank = value['rank'].to_i
        element
    end
end

def prepare(data, spots_needed = [])
    # put spots needed at the begining of array
    first, last = 0, data.length-1
    while first < last
        while spots_needed.include?(data[first].id) and first < last
            first += 1
        end
        while !spots_needed.include?(data[last].id) and first < last
            last -= 1
        end
        if first < last
            temp = data[first]
            data[first] = data[last]
            data[last] = temp
        end
        first += 1
        last -= 1
    end
    # find the first element not needed
    iterator = 0
    while iterator < data.length - 1
        break if !spots_needed.include?(data[iterator])
        iterator += 1
    end
    # sort by max_time
    first, last = 0, data.length-1
    for i in first..iterator-1
        for j in i+1..iterator-1
            if data[i].stay_time[:max_time] < data[j].stay_time[:max_time] or
                (data[i].stay_time[:max_time] == data[j].stay_time[:max_time] and data[i].stay_time[:min_time] < data[j].stay_time[:min_time])
                temp = data[i]
                data[i] = data[j]
                data[j] = temp
            end
        end
    end
    for i in iterator..data.length-1
        for j in i+1..data.length-1
            if data[i].stay_time[:max_time] < data[j].stay_time[:max_time] or
                (data[i].stay_time[:max_time] == data[j].stay_time[:max_time] and data[i].stay_time[:min_time] < data[j].stay_time[:min_time])
                temp = data[i]
                data[i] = data[j]
                data[j] = temp
            end
        end
    end
    data
end

def print(data)
    data.each do |datum|
        #puts "#{key}: stay_time -> #{value['stay_time']}, opening_hours -> #{value['opening_hours']}"
        puts "#{datum.id}: -> #{datum.stay_time[:max_time]} - #{datum.stay_time[:min_time]}"
    end
end

def build_result(result, message, schedule)
    {result: result, message: message, schedule: schedule}
end
#PLAN_METHOD = 
def plan(formated_data, day_count, spots_needed=[], max_spots=5, max_hours=10)
    map = {}
    map[:visited] = []
    for i in 0..formated_data.length-1
        map[:visited] << false
    end
    for i in 0..day_count
        map[i] = {spots_left: max_spots,
                  morning: {
                    hours_left: max_hours/2,
                    spots: []
            },
                  afternoon: {
                    hours_left: max_hours - max_hours/2,
                    spots: []
            }
        }
    end
    for i in 0..formated_data.length-1
        supported = false
        for j in 0..day_count
            next if map[j][:spots_left] <= 0
            if map[j][:morning][:hours_left] >= formated_data[i].stay_time[:max_time]
                map[j][:morning][:hours_left] -= formated_data[i].stay_time[:max_time]
                map[j][:morning][:spots] << {spot: formated_data[i].id, time: formated_data[i].stay_time[:max_time]}
                supported = true
                map[:visited][i] = true
                map[j][:spots_left] -= 1
                break
            end
            if map[j][:afternoon][:hours_left] >= formated_data[i].stay_time[:max_time]
                map[j][:afternoon][:hours_left] -= formated_data[i].stay_time[:max_time]
                map[j][:afternoon][:spots] << {spot: formated_data[i].id, time: formated_data[i].stay_time[:max_time]}
                supported = true
                map[:visited][i] = true
                map[j][:spots_left] -= 1
                break
            end
        end
        break if !supported
    end
    return map if map[:visited][map[:visited].length-1]
    
    for i in 0..map[:visited].length-1
        map[:visited][i] = false
    end
    for i in 0..formated_data.length-1
        supported = false
        for j in 0..day_count
            next if map[j][:spots_left] <= 0
            if map[j][:morning][:hours_left] >= formated_data[i].stay_time[:min_time]
                map[j][:morning][:hours_left] -= formated_data[i].stay_time[:min_time]
                map[j][:morning][:spots] << {spot: formated_data[i].id, time: formated_data[i].stay_time[:min_time]}
                supported = true
                map[:visited][i] = true
                map[j][:spots_left] -= 1
                break
            end
            if map[j][:afternoon][:hours_left] >= formated_data[i].stay_time[:min_time]
                map[j][:afternoon][:hours_left] -= formated_data[i].stay_time[:min_time]
                map[j][:afternoon][:spots] << {spot: formated_data[i].id, time: formated_data[i].stay_time[:min_time]}
                supported = true
                map[:visited][i] = true
                map[j][:spots_left] -= 1
                break
            end
        end
        break if !supported
    end
    map
end

formated_data = extract(result)
print prepare(formated_data)
puts '----------------------------------------------------------'
prepared_data = prepare(formated_data)
#p plan(prepare(prepared_data), 5)
p plan(prepare(prepared_data), 4)
