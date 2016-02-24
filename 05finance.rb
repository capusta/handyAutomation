begin
  require 'optparse'
  require 'json'
  require 'ostruct'
  require 'fileutils'
  require 'rio'
  require 'rinruby'
  require 'net/http'
  require 'set'
  require 'date'
rescue Gem::LoadError
  `gem install rio`
  `gem install rinruby`
end

#File checking library cuz it looks like we use it a lot
require_relative '__lib/common.rb'

@options = OpenStruct.new
@options.debug    = false
@options.api      = nil
@options.config   = "_05finance/config.conf"
@options.currency = "jpy"
@categories       = Set.new
@categories_uniq  = Set.new
@transactions     = []

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

  opts.on("-r", "--currency c", "change to your local currency") do |v|
    @options.currency = v
  end

end.parse!

gracefulExit("missing api") if @options.api.nil?
gracefulExit("missing configuration file ") if @options.config.nil?

checkFile(@options.config)
# Going to check all of the file prerequesites
rio(@options.config).chomp.lines(/^expense_file/) {|f|
  @expense_file = f.split("=>")[1].strip.to_s
  checkFile @expense_file
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
rio(@categories_file).chomp.lines {|l|
  next if l.empty?
  next if l.nil?
  c = l.split("=>")
  v = c[1].strip.to_s
  k = c[0].strip.to_s
  @categories_uniq.add(v)
  @categories.add([k,v])
}
# Populate the initial values at the beginning of the year
@categories_uniq.each {|c|
  if rio(@archive_file).chomp.lines[/Initial #{c}/].length != 12 then
    for i in 1..12 do
      @transactions << "0.0,Initial #{c},#{c},#{ Date.new(Date.today.year,i,1).strftime(@date_format)}"
    end

  end
  }

uri = URI.parse("http://currency-api.appspot.com/api/USD/#{@options.currency}.json?key=#{@options.api}")
resp = JSON.parse(Net::HTTP.get(uri))
if resp.has_key? 'Error'
  raise "web service error"
end
rate = resp['rate'].to_f.round(2)
puts "rate found: #{rate}"

# --- Main parsing of the file is here
#
@tryDate  = false
@currDate = false

# Quick Helper to remember the currently processing date
#
#
def checkFound
  if @tryDate then
    @currDate = @tryDate
    @tryDate = false
    return true
  end
  return false
end

# Nice formatting for the transaction
def processExpenseItem(_line)
item = Hash.new
  @categories.each do |kv|
    if (_line.include? kv[0])
      item[:category] = kv[1]
    else
      item[:category] = 'Unknown'
    end
  end

return "#{item[:amount]},#{item[:description]},#{item[:date]},#{item[:category]}"

end

rio(@expense_file).lines { |line|
  @tryDate = DateTime.strptime(line, @date_format) rescue nil
  next if checkFound
  #throw "Unable to find and / or parse date" if !@currDate

  #@transactions << processExpenseItem(line)
}

# Write all transactions to the archive file
@transactions.each { |t|
  rio(@archive_file).noautoclose << "#{t}\n"
}

# Reset the expense log
rio(@expense_file) < ""
puts '05 finance done'

exit 0
