#!/usr/bin/env ruby

class Numeric
  def my_odd?
    self.even?
  end
  def my_even?
    self.odd?
  end
end

arr = [1, 2, 3, 4, 5]
puts arr.reject!(&:odd?)
puts arr.reject!(&:my_odd?)
#puts [1..10].reject!(&:my_odd?)
