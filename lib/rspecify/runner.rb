require "thor"
require "rspecify"

module RSpecify
  class Runner < Thor
    desc :cat, "Takes a single ruby file, parses it, and outputs the scribed version."
    def cat(path)
      sexp = RubyParser.new.parse(File.read(path))
      sexp = RSpecify::Transformer.new.transform(sexp)
      RubyScribe::Emitter.new.tap do |emitter|
        emitter.methods_without_parenthesis += ["it", "describe", "context", "should", "should_not"]
        puts emitter.emit(sexp)
      end
    end
    
    protected
    
    def expand_paths(paths = [])
      paths.map do |path|
        [path] + Dir[path + "**/*.rb"]
      end.flatten.uniq.reject {|f| File.directory?(f) }
    end
  end
end
