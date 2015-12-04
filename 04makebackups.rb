require 'erb'
require 'optparse'
require 'ostruct'
require 'rio'
require 'fileutils'

@options = OpenStruct.new
@options.hashname = 'ffsync/_current.data'
@options.mode = 'unknown'
@options.outFile = 'ffsync/backup.ffsync'
@options.templateFile = 'ffsync/_template.ffsync.erb'
@options.directories = {}
@options.logfile = nil
@options.versioning = nil

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
      else p 'no mode specified.  pick either: add or remove'
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
  opts.on('-l', '--logfile l') do |v|
    throw "log file #{v} is a directory" if File.directory?(v)
    @options.logfile = v
    puts "logging to #{v}" if @options.debug
  end
    #### VERSIONING
  opts.on('-v', '--versioning l') do |v|
    throw "log file #{v} is not a directory" if !File.directory?(v)
    @options.versioning = v
    puts "keeping changed files in #{v}" if @options.debug
  end
end

@options.directories['c:\\windows\\dirOne'] = 'c:\\windows\\dirOnebackups'
@options.directories['c:\\windows\\dirTwo'] = 'c:\\windows\\dirTwobackups'

opt_parse.parse!
b = binding
File.open(@options.outFile, 'w') do |file|
  file.puts(ERB.new(File.read(@options.templateFile),nil,'-').result(b))
end

throw "please add a mode: -m [add | remove]" if @options.mode == 'unknown'
puts @options.to_s if @options.debug
