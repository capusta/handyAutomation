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


opt_parse = OptionParser.new do |opts|
  opts.banner = "Usage: 04makebackups.rb [@options]"
  opts.on('-d', '--debug') do |v|
    @options.debug = true
    end
  opts.on('-m', '--mode m') do |m|
    case m
      when 'add' then @options.add = true
      when 'remove' then @options.remove = true
      else p 'no mode specified.  pick either: add or remove'
        exit
    end
    end
  opts.on('-f', '--from f') do |v|
    ans = File.directory?(v || "")
    throw "invalid input directory #{v}" if !ans
    v << "/" unless v[v.length-1] == "/"
    @options.from = v
    p "input dir OK #{v}" if @options.debug
  end
  opts.on('-t', '--to t') do |v|
    ans = File.directory?(v || "")
    throw "invalid input directory #{v}" if !ans
    v << "/" unless v[v.length-1] == "/"
    @options.to = v
    p "output dir OK #{v}" if @options.debug
  end
end

@options.directories['c:\\windows\\dirOne'] = 'c:\\windows\\dirOnebackups'
@options.directories['c:\\windows\\dirTwo'] = 'c:\\windows\\dirTwobackups'

b = binding
File.open(@options.outFile, 'w') do |file|
  file.puts(ERB.new(File.read(@options.templateFile),nil,'-').result(b))
end

puts @options.directories
opt_parse.parse!
