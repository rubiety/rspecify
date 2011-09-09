require "rubygems"
require "ruby_parser"
require "ruby_scribe"
require "ruby_transform"

require "rspecify/transformer"

Dir[File.join(File.dirname(__FILE__), "rspecify/transformers/**/*.rb")].each do |file|
  require file
end
