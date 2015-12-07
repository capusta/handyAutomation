require 'erb'
require 'optparse'
require 'ostruct'
require 'rio'
require 'fileutils'

@options = OpenStruct.new
@options.currentData = 'ffsync/_current.data'
@options.mode = 'list'
@options.outFile = 'ffsync/backup.ffs_batch'
@options.templateFile = 'ffsync/_template.ffsync.erb'
@options.directories = {}
@options.logfile = nil
@options.versioning = nil
@options.toRemove = nil

opt_parse = OptionParser.new do |opts|
  opts.banner = "Usage: 04makebackups.rb [@options]"
  #### DEBUG
  opts.on('-d', '--debug') do |v|
    @options.debug = true
  end
  #### MODE
  opts.on('-m', '--mode m') do |m|
    case m
      when 'add' then @options.mode = 'add'
      when 'remove' then @options.mode = 'remove'
      else puts 'no mode specified.'
        exit
    end
  end
  #### FROMDIR
  opts.on('-f', '--from f') do |v|
    ans = File.directory?(v || "")
    throw "invalid input directory #{v}" if !ans
    @options.from = v
    p "input dir OK #{v}" if @options.debug
  end
    #### TODIR
  opts.on('-t', '--to t') do |v|
    ans = File.directory?(v || "")
    throw "invalid input directory #{v}" if !ans
    @options.to = v
    p "output dir OK #{v}" if @options.debug
  end
    #### LOGFILE
  opts.on('-l', '--logdir l') do |v|
    throw "log file #{v} is not a directory" if !File.directory?(v)
    @options.logfile = v
    puts "logging to #{v}" if @options.debug
  end
    #### VERSIONING
  opts.on('-v', '--versioning l') do |v|
    throw "log file #{v} is not a directory" if !File.directory?(v)
    @options.versioning = v
    puts "keeping changed files in #{v}" if @options.debug
  end
    #### DELETE DIR FROM BACKUP
  opts.on('-r', '--remove l') do |v|
    throw "Dir to be removed #{v} in not a valid direcotry" if !File.directory?(v)
    @options.toRemove = v
    #puts "removing #{v}" if @options.debug
  end
end

opt_parse.parse!
debug = @options.debug

temp = rio(@options.currentData).lines(0..2).chomp.to_a
#temp[0] #logfile
temp[1] #versioning
temp[2] #to remove

@options.logdir     = @options.logdir || temp[0]
@options.versioning = @options.versioning || temp[1]
@options.toRemove   = @options.toRemove || temp[2]


# Quick sanity check
if (@options.mode == 'add' and !(@options.from and @options.to)) then
  throw "need a pair of directories from and to -m add -f /dir1 -t /dir2"
end

if @options.mode == 'add' then
  @options.directories[@options.from] = @options.to
end

rio(@options.currentData).lines(3..File.open(@options.currentData).readlines.size).chomp { |l|
puts "reading #{l}" if debug
  temp = l.split('=>')
  puts l.length < 4 if debug
  next if l.length < 4
  @options.directories[temp[0]] = temp[1]
}

if @options.mode == 'list' then
    _nd = @options.directories.length
    puts "#{_nd} directories loaded:"
    puts 'maybe you would like to add some with mode [-m add] flag?' if _nd == 0
    @options.directories.each do |d|
      puts "#{d}" if debug
    end
end

puts @options.to_s if @options.debug # debug is really long
b = binding
File.open(@options.outFile, 'w') do |file|
  file.puts(ERB.new(File.read(@options.templateFile),nil,'-').result(b))
end

# Top three lines in status file are taken
puts "final directories length #{@options.directories.length}" if @options.debug
rio(@options.currentData) < ""
rio(@options.currentData) << "#{@options.logfile}\n"
rio(@options.currentData) << "#{@options.versioning}\n"
rio(@options.currentData) << "#{@options.toRemove}\n"
@options.directories.each do |k,v|
  puts  k if debug
  rio(@options.currentData) << "#{k}=>#{v}"
end

