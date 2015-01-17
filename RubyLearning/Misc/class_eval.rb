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
# class_eval可进入类定义体中
#
##########################################################################
if seq += 1 and eid == seq 
  class MyClass
  end

  MyClass.class_eval do
    def hello_world
      puts "Hello, World!"
    end
  end

  MyClass.new.hello_world
end

##########################################################################
#
# class_eval可以访问外围作用域的变量
#
##########################################################################
if seq += 1 and eid == seq 
  var = "hello world"

  class C
    if $DEBUG
      puts var
    end
  end

  C.class_eval {
    puts var
  }
end

##########################################################################
#
# class_eval块中定义一个实例方法时，又有不同
#
##########################################################################
if seq += 1 and eid == seq 
  puts "aaa"
  var = "test"
  class C
  end

  C.class_eval {
    def hello; puts var; end
  }
  if $DEBUG
    C.new.hello
  end
  #但是可以使用另外一种方法
  C.class_eval {
    define_method("hi") {
      puts var
    }
  }
  C.new.hi
end

