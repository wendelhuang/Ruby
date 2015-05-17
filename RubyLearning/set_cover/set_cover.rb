#!/usr/bin/env ruby 

require 'set' 

class Set 
  def cover(s) 
    count = 0 
    self.each do |element| 
      count += 1 if s.include?(element) 
    end 
    return count 
  end 
end

class BuildData
  def self.random_number
    return rand(20) + 1
  end
  def self.build_data
    @S = Hash.new
    s_length = random_number
    for i in 1..s_length do
      si_length = random_number
      si = []
      for j in 1..si_length do
        si << random_number
      end
      @S[i] = Set.new si
    end
    ss = Set.new
    for i in 1..@S.length do
      ss += @S[i]
    end
    if ss.length != 20
      return build_data
    else
      return @S
    end
  end
end

class Test 
  def initialize(s)
    @S = s.dup

    puts "------------------------------------"
    for i in 1..@S.length do
      puts "@S[#{i}] = Set.new [#{@S[i].to_a.join(',')}]"
    end
  end 
  
  def step1 
    arr = []
    for i in 1..10 do
      arr << i
    end
    @E = Set.new arr
  end 

  def step2 
    @X, @C, @T = @E.dup, Set.new, Hash.new 
    for i in 1..@S.length do 
      h_temp = Hash.new 
      for j in i+1..@S.length do 
        h_temp[j] = @S[i] + @S[j] 
      end 
      @T[i] = h_temp 
    end 
    @k = 1 
  end 

  def step3 
    @uk, @vk = Hash.new, Hash.new 
    while @X.length != 0 do 
      @Y = @X.dup 
      num_i, num_j, num_count = 1, 2, -1 
      for i in 1..@S.length do 
        for j in i+1..@S.length do 
          if !@T[i].nil? && !@T[i][j].nil? 
            cover_number = @T[i][j].cover(@X) 
            num_i, num_j, num_count = i, j, cover_number if cover_number > num_count 
          end 
        end 
      end 
      @uk[@k], @vk[@k] = @S[num_i], @S[num_j] 
      @X = @X - @T[num_i][num_j] 
      @C.add(@S[num_i]) 
      @C.add(@S[num_j]) 

      @T.delete(num_i) if !@T[num_i].nil? 
      for i in 1..@S.length do 
        @T[i].delete(num_j) if !@T[i].nil? && !@T[i][num_j].nil? 
      end 
      @k += 1 
    end 
  end 

  def step4 
    if @X.length == 0 
      if @Y.subset? @uk[@k-1] 
        @C -= @vk[@k-1] 
      elsif @Y.subset? @vk[@k-1] 
        @C -= @uk[@k-1] 
      end 
    end 
#    print_set @C
    return @C.length
  end 

  def print_set(s) 
    print "{" 
    s.each do |ss| 
      print "{" 
      print ss.to_a.join(',') 
      print "}" 
    end 
    puts "}" 
  end 
end 

class GreedySetCover 
  def initialize(s)
    arr = []
    for i in 1..20 do
      arr << i
    end
    @U = Set.new arr
    @S = s.dup
    @C = Set.new 
  end 

  def greedy 
    while f < @U.length do 
      num_i, set_len = 1, -1 
      for i in 1..@S.length do 
        u = Set.new
        @C.each do |c|
          u += c
        end
        u += @S[i]
        num_i, set_len = i, u.length if set_len < u.length 
      end 
      @C.add(@S[num_i]) 
    end 
#    print_set(@C) 
    return @C.length
  end 

  def print_set(s) 
    print "{" 
    s.each do |ss| 
      print "{" 
      print ss.to_a.join(',') 
      print "}" 
    end 
    puts "}" 
  end 

  def f 
    s = Set.new 
    @C.each do |c| 
      s += c 
    end 
    return s.length 
  end 
end 


class TestProfile 
  def test_profile 
    time_begin = Time.now 
    for i in 1..2000 do 
      test = Test.new 
      test.step1 
      test.step2 
      test.step3 
      test.step4 
    end 
    time_end = Time.now 
    puts "#{time_end}-#{time_begin} = #{time_end - time_begin}" 

    time_begin = Time.now 
    for i in 1..2000 do 
      greedy = GreedySetCover.new 
      greedy.greedy 
    end 
    time_end = Time.now 
    puts "#{time_end}-#{time_begin} = #{time_end - time_begin}" 
  end 
  def test_set_number_profile
    count1, count2 = 0, 0
    for i in 1..2000 do
      s = BuildData.build_data
      
      test = Test.new(s)
      test.step1 
      test.step2 
      test.step3 
      count_test = test.step4 
      
      greedy = GreedySetCover.new(s)
      count_greedy = greedy.greedy

      if count_test < count_greedy
        count1 += 1
      elsif count_test == count_greedy
        count2 += 1
      end
    end
    puts "You win #{count1}, draw #{count2} greedy wins #{2000-count1-count2}"
  end
end 

test = TestProfile.new 
#test.test_profile 
test.test_set_number_profile 

=begin
test = Test.new 
test.step1 
test.step2 
test.step3 
test.step4

greedy = GreedySetCover.new 
greedy.greedy 
=end
