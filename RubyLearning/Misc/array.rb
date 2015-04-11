#!/usr/bin/env ruby

eid = ENV['EID'].nil? ? 1 : ENV['EID'].to_i
seq = 0

if ENV['EID'].nil?
  puts "没有设置EID，默认执行第一个示例"
else
  puts "执行第#{eid}个示例"
end
puts "--------------------------------------------------------------------"
##########################################################################
#
# 
#
##########################################################################
if seq += 1 and eid == seq 
  args = ['-m', '-n', '-o', '-p', '-q']
  first_ele = args.shift
  puts "first_ele=#{first_ele}, args=#{args}"
end
