#!/usr/bin/env ruby

require 'syncify'

foo = Syncify::Syncify.new
foo.configure do |config|
  config[:store] = "bar"
end

puts foo.configuration