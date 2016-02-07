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
@options.currency = "jpy"

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

uri = URI.parse("http://currency-api.appspot.com/api/USD/#{@options.currency}.json?key=#{@options.api}")
resp = JSON.parse(Net::HTTP.get(uri))
if resp.has_key? 'Error'
  raise "web service error"
end
rate = resp['rate'].to_f.round(2)
puts "rate found: #{rate}"

# Going to check all of the file prerequesites
rio(@options.config).chomp.lines(/^expense_file/) {|f|
  @inputFile = f.split("=>")[1].strip.to_s
  checkFile @inputFile
}
rio(@options.config).chomp.lines(/^archive_file/) {|f|
  @archive_file = f.split("=>")[1].strip.to_s
  checkFile @archive_file
}
rio(@options.config).chomp.lines(/^categories_file/) {|f|
  @categories_file = f.split("=>")[1].strip.to_s
  checkFile @categories_file
}
rio(@options.config).chomp.lines(/^reports_folder/) {|f|
  @reports_folder = f.split("=>")[1].strip.to_s
  checkDir @reports_folder
}  
rio(@options.config).chomp.lines(/^date_format/) {|f|
  @date_format = f.split("=>")[1].strip.to_s
}  

# Ready to parse all categories
#TODO: actually parse this
rio(@categories_file).chomp.lines {|l|
  puts l
}



  
puts '05 finance done'
exit 0
