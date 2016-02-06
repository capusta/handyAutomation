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

  opts.on("-p", "--api api", "api needed for conversion") do |api|    
    @options.api = api
  end
  
  opts.on("-s", "--settings file", "Includes all of your settings ... locations, categories, etc") do |v|
    @options.config = checkFile(v || "./_05finance/config.conf")
  end
  
end.parse!

gracefulExit("missing api") if @options.api.nil?
gracefulExit("missing configuration file ") if @options.config.nil?

puts '05 finance done'
exit 0
