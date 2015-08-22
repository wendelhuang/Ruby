#!/usr/bin/env ruby

module SafeAttributes
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def safe_attributes(*args)
      if args.empty?
        @safe_attributes
      else
        @safe_attributes ||= []
        options = args.last.is_a?(Hash) ? args.pop : {}
        @safe_attributes << [args, options]
      end
    end
  end
end

class MyModel
  include SafeAttributes
  
  safe_attributes 'name', 'age'
end


puts MyModel.safe_attributes
