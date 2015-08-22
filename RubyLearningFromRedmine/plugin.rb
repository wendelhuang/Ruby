#!/usr/bin/env ruby

class Plugin
  @@directory = "plugins"
  @@registed_plugins = {}
  def register(id)
    @@registed_plugins[id.to_sym] = {}
  end
  def registed_plugins
    @@registed_plugins
  end
end

Plugin.new.register :a
Plugin.new.register :b
puts Plugin.new.registed_plugins
