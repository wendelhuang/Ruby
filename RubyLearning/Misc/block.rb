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
# 可以在方法中把代码块转换成Proc对象
# 可以通过参数中最后一个变量，且必须以&开头来捕获代码块
#
##########################################################################
if seq += 1 and eid == seq 
  def call_block(&block)
    block.call
  end
  call_block {puts "hello"}

  def call_block_with_para(x, y, &block)
    puts "#{x}+#{y} = #{x+y}"
    block.call
  end
  call_block_with_para(1, 2) {puts "hello"}
end

##########################################################################
#
# 也可以将Proc对象或lambda转换为代码块
#
##########################################################################
if seq += 1 and eid == seq 
  def call_block_by_lambda(&block)
    block.call
  end

  lam = lambda {puts "hello"}
  call_block_by_lambda(&lam)
end
