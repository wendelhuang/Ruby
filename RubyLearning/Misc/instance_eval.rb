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
# instance_eval把self变成instance_eval调用的接收者
#
##########################################################################
if seq += 1 and eid == seq 
  if !$DEBUG.nil?
  end

  p self
  a = []
  a.instance_eval do
    p self
  end
end

##########################################################################
#
# instance_eval常用于访问其他对象的私有数据，特别是实例变量
#
##########################################################################
if seq += 1 and eid == seq 
  class MyClass
    def initialize
      @var = 1
    end
  end

  myclass = MyClass.new
  myclass.instance_eval {
    p @var
  }
end
