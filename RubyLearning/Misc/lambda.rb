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
# lambda不是Lambda类的对象，她们是Proc类的对象
#
##########################################################################
if seq += 1 and eid == seq 
  lam = lambda { puts "hello" }
  lam.call
  #Proc
  puts lam.class
end

##########################################################################
#
# lambda生成的Proc对象和用Proc.new生成的对象之间的差别和return有关
# lambda中的return从lambda返回
# Proc中的return从外围方法返回
#
##########################################################################
if seq += 1 and eid == seq
  def test_return
    lam = lambda {return}
    pr = Proc.new {return}

    lam.call
    puts "can reach here"
    pr.call
    puts "cannot reach here"
  end

  test_return
end
