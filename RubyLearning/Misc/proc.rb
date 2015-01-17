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
# Proc对象随身携带了它的上下文
# 闭包中可以有自己的变量，该变量被赋值为一个特殊的字符串保存在Proc对象中
# 这样带着产生这个闭包时上下文信息的一段代码称为闭包
# 产生一个闭包就像打包意见行李，任何时候打开行李，都是你放进去时候的样子
# 闭包也一样，打开一个闭包时，里面是产生它的时候放进去的东西
#
##########################################################################
if seq += 1 and eid == seq 
  def call_proc(prc)
    var = "foo"
    puts "define variable [var] = #{var}"
    prc.call
  end

  var = "bar"
  puts "define variable [var] = #{var}"
  pr = Proc.new {
    puts "in Proc, [var] = #{var}"
  }
  pr.call
  call_proc(pr)
end

##########################################################################
#
# 产生Proc对象时提供的代码块可以接收参数
#
##########################################################################
if seq += 1 and eid == seq 
  pr = Proc.new { |para|
    puts "in proc, parameter is #{para}"
  }
  pr.call("random para")
end
