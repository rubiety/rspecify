require "thor"
require "rspecify"

module RSpecify
  class Runner < Thor
    desc :cat, "Takes a single ruby file, parses it, and outputs the scribed version."
    def cat(path)
      sexp = RubyParser.new.parse(File.read(path))
      sexp = RSpecify::Transformer.new.transform(sexp)
      puts RubyScribe::Emitter.new.emit(sexp)
    end
    
    protected
    
    def expand_paths(paths = [])
      paths.map do |path|
        [path] + Dir[path + "**/*.rb"]
      end.flatten.uniq.reject {|f| File.directory?(f) }
    end
  end
end
