#!/usr/bin/env ruby

##########################################################################
#
# instance_eval把self变成instance_eval调用的接收者
#
##########################################################################

if !$DEBUG.nil?
end

p self
a = []
a.instance_eval do
  p self
end


##########################################################################
#
# instance_eval常用于访问其他对象的私有数据，特别是实例变量
#
##########################################################################

class MyClass
  def initialize
    @var = 1
  end
end

myclass = MyClass.new
myclass.instance_eval {
  p @var
}
