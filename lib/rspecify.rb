require "rubygems"
require "active_support"
require "ruby_parser"
require "ruby_scribe"

require "rspecify/transformer"

Dir[File.join(File.dirname(__FILE__), "rspecify/transformers/**/*.rb")].each do |file|
  require file
end
