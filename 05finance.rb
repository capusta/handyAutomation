begin
  require 'optparse'
  require 'json'
  require 'ostruct'
  require 'fileutils'
  require 'rio'
  require 'rinruby'
  require "net/http"

rescue LoadError
  `gem install rio`
  `gem install rinruby`
end



#File checking library cuz it looks like we use it a lot
require_relative '__lib/common.rb'

@options = OpenStruct.new
@options.debug = false
@options.api = nil
@options.config = "./_05finance/config.conf"

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
    puts "checking settings file " if @options.debug
    @options.config = checkFile(v || @options.debug)
  end
  
end.parse!

gracefulExit("missing api") if @options.api.nil?
gracefulExit("missing configuration file ") if @options.config.nil?

uri = URI.parse("http://currency-api.appspot.com/api/USD/Jpy.json?key=#{@options.api}")
resp = JSON.parse(Net::HTTP.get(uri))
if resp.has_key? 'Error'
  raise "web service error"
end
puts resp if @options.debug
puts '05 finance done'
exit 0
