require 'erb'
require 'optparse'
require 'ostruct'
require 'rio'
require 'fileutils'

@options = OpenStruct.new

def set_default()
  @options.currentData = 'ffsync/_current.data'
  @options.mode = 'list'
  @options.outFile = 'ffsync/backup.ffs_batch'
  @options.templateFile = 'ffsync/_template.ffsync.erb'
  @options.directories = {}
  @options.logfile = nil
  @options.versioning = nil
  @options.toRemove = nil
end

set_default

opt_parse = OptionParser.new do |opts|
  opts.banner = "Usage: 04makebackups.rb [@options]"
  #### DEBUG
  opts.on('-d', '--debug') do |v|
    @options.debug = true
  end
  #### MODE
  opts.on('-a', '--add') do
      @options.mode = 'add'
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
  opts.on('-r', '--remove v') do |v|
    throw "Dir to be removed #{v} in not a valid direcotry" if !File.directory?(v)
    @options.toRemove = v
    @options.mode = 'remove'
  end
  opts.on('--reset') do
    rio(@options.currentData) < "\n\n\n\n"
    set_default
  end
end

opt_parse.parse!
debug = @options.debug

## Normal operations here

## Lines 0,1,2 are reserved
temp = rio(@options.currentData).lines(0..1).chomp.to_a
@options.logdir     = @options.logdir || temp[0].chomp
@options.versioning = @options.versioning || temp[1].chomp

rio(@options.currentData).lines(2..File.open(@options.currentData).readlines.size).chomp { |l|
  #puts "reading #{l}" if debug
  temp = l.split('=>')
  puts " - direcotry #{l} length is OK:  #{!(l.length < 4)}" if debug
  next if l.length < 4
  @options.directories[temp[0]] = temp[1]
}

# Quick sanity check
if (@options.mode == 'add' and !(@options.from and @options.to)) then
  throw "need a pair of directories from and to -m add -f /dir1 -t /dir2"
end

if @options.mode == 'add' then
  @options.directories[@options.from] = @options.to
end


if @options.mode == 'remove' then
    puts "removing #{@options.toRemove}"
    @options.directories.delete(@options.toRemove)
end

if @options.mode == 'list' then
    _nd = @options.directories.length
    puts "#{_nd} directories loaded:"
    puts 'maybe you would like to add some with mode [-m add] flag?' if _nd == 0
    @options.directories.each do |k,v|
      puts "#{k} ---> #{v}"
    end
    puts "log dir:    #{@options.logfile}"
    puts "versioning: #{@options.versioning}"
end



#puts @options.to_s if @options.debug # debug is really long
b = binding
File.open(@options.outFile, 'w') do |file|
  file.puts(ERB.new(File.read(@options.templateFile),nil,'-').result(b))
end

# Top three lines in status file are taken
puts "final directories length #{@options.directories.length}" if @options.debug
rio(@options.currentData) < ""
rio(@options.currentData) << "#{@options.logfile}\n"
rio(@options.currentData) << "#{@options.versioning}\n"
@options.directories.each do |k,v|
  next if k.nil?
  puts  k if debug
  rio(@options.currentData) << "#{k}=>#{v}\n"
end

