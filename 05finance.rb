require 'optparse'
require 'ostruct'

#File checking library cuz it looks like we use it a lot
require_relative '__lib/filecheck.rb'

@options = OpenStruct.new
@options.debug = false

OptionParser.new do |opts|
  opts.banner = "Usage: ruby 05finance.rb [@options]"

  opts.on("-d", "--debug", "displays a ton of useless info") do
    @options.debug = true
    puts "debug mode is on " if @options.debug
  end
  
  opts.on("-i", "--input dir", "input file to parse") do |v|
    @options.expFile = checkDir(v)
  end

end.parse!

puts '05 finance done'
exit 0
