begin
  require 'optparse'
  require 'ostruct'
  require 'fileutils'
  require 'rio'
  require 'rinruby'
rescue LoadError
  `gem install rio`
  `gem install rinruby`
end



#File checking library cuz it looks like we use it a lot
require_relative '__lib/common.rb'

@options = OpenStruct.new
@options.debug = false
@options.api = nil

OptionParser.new do |opts|
  opts.banner = "Usage: ruby 05finance.rb [@options]"

  opts.on("-d", "--debug", "displays a ton of useless info") do
    @options.debug = true
    puts "debug mode is on " if @options.debug
  end
  
  opts.on("-i", "--input file", "input file to parse") do |v|
    @options.expFile = checkFile(v)
  end
  
  opts.on("-a", "--archive file", "Archive file of all expenses") do |v|
    puts "checking archive"
    @options.archiveFile = checkFile(v)
  end
  
  opts.on("-p", "--api api", "api needed for conversion") do |api|
    @options.api = api
  end

  opts.on("-c", "--createmissing", "create all missing files") do |v|
    @options.createmissing = true
  end
  
end.parse!

gracefulExit("missing api") if @options.api.nil?
[@options.expFile, @options.archiveFile].each { |d| 
  puts "test #{d}"
}
puts '05 finance done'
exit 0
