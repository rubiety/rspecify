require "thor"
require "rspecify"

module RSpecify
  class Runner < Thor
    desc :cat, "Takes a single ruby file, parses it, and outputs the scribed version."
    def cat(path)
      sexp = RubyParser.new.parse(File.read(path))
      puts RubyScribe::Emitter.new.emit(sexp)
    end
    
    desc :convert, "Takes a single file or multiple files, parses them, then replaces the original file(s) with the scribed version."
    def convert(*paths)
      expand_paths(paths).each do |path|
        sexp = RubyParser.new.parse(File.read(path))
        output = RubyScribe::Emitter.new.emit(sexp)
        
        File.open(path, "w") do |file|
          file.write(output)
          file.flush
        end
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
