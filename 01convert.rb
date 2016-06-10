require 'optparse'
require 'ostruct'
require 'digest'
require 'find'
require 'mini_exiftool'
require 'fileutils'
require 'rio'

commonDir = Dir.pwd+"/_01convert"
Dir.mkdir commonDir if !File.exist? commonDir
require_relative '__lib/common.rb'

@options = OpenStruct.new
@options.hashname = "#{commonDir}/seenhash.xml"
@options.exiftool = "#{commonDir}/exiftool.exe"
# Please edit the path to your exif tool ... assuming current directory
# you cand download it for windows here
# http://www.sno.phy.queensu.ca/~phil/exiftool/install.html#Windows

opt_parse = OptionParser.new do |opts|
  opts.banner = "Usage: convert.rb [@options]"

  opts.on( "-d", "--debug") do |v|
    @options.debug = true
  end

  opts.on("-m", "--mode style") do |s|
    case s
      when 'movie' then @options.movieMode = true
      when 'photo' then @options.photoMode = true
      else  puts "No mode specified in '-m'"
      exit
    end
  end

  opts.on("--norename") do |s|
    @options.norename = true
  end

  opts.on("-i", "--input dir") do |s|
    p "checking input dir #{s}" if @options.debug
    @options.inputDir = checkDir(s)
  end

  opts.on("-o", "--output dir") do |v|
    p "checking output dir #{v}" if @options.debug
    @options.outputDir = checkDir(v)
  end

  opts.on("--exif tool") do |e|
    @options.exiftool = checkFile(e || @options.exiftool)
  end
end

def do_video
  return nil if !@options.movieMode
  debug = @options.debug
  if File.exist?('runInProgress') then
    p 'run already in progress, exiting' if debug
    FileUtils.touch('runRequested')
    exit
  end
  FileUtils.touch('runInProgress')
  
  seenHash = {}
  
  if File.exist?(@options.hashname) then
    rio(@options.hashname).chomp.lines{ |l|
      seenHash[l.split("||")[0].chomp.strip] = true
    }
  end
  p "loaded #{seenHash.length} hashes" if @options.debug
  p 'starting movie mode' if @options.debug
  
  ignore = ["sample", "etrg.mp4", "rarbg.com"]
  approve = [".avi",".mov",".mp4",".mkv",".m4v"]

  Find.find(@options.inputDir){|f|
    next if File.directory?(f)
    next if ignore.any? {|g| f.downcase.include? g}
    next if !approve.any? {|g| f.downcase.include? g}
    debug = @options.debug
    puts "hashing ...#{f}" if debug
    myhash = Digest::MD5.file f
    if seenHash["#{myhash}"] then
      p "Already seen: #{File.basename(f)}"
      next
    end

    mov = MiniExiftool.new f
    movDate = mov["MediaCreateDate"] || mov.filecreatedate
    mov_yr_mon_day = movDate.strftime("%Y.%m.%d")
    mov_yr_mon = movDate.strftime("%Y.%m")
    p "Exif Creation: #{mov_yr_mon_day}" if debug
    p "#{File.basename(f,".*")}", "#{myhash}" if debug
    mov_yr_mon_day = "" if @options.norename
    outname = mov_yr_mon_day+"-"+File.basename(f,".*")+".mp4"

    #quasi sorting of movies - handy for bulk
    nestedDir = @options.outputDir+mov_yr_mon_day
    if !File.exist? nestedDir then
      Dir.mkdir nestedDir
    end
    if !File.exist? "#{@options.inputDir}/completed" then
      Dir.mkdir "#{@options.inputDir}/completed"
    end
    outname = nestedDir+"/"+outname
    p "saving to #{outname}" if debug

   ### Rotationgs - --roate <mode> 1. Vertical flip 2. horizontal flip 4. clockwise
    rotation_option = case mov['Rotation']
      when 90 then '--rotate=4'
      when 180 then '--rotate=3'
      when 270 then '--rotate=7'
      else ''
    end
    puts " Detected ROTATION: #{mov.rotation}" if debug
    cmd = "\"#{@options.handbrake}\" -i \"#{f}\" -o \"#{outname}\" -e x264 #{rotation_option}"
    cmd += " -q 22.0 -r 30 --pfr -a 1 -E faac -B 160 -6 dpl2 -R Auto -D 0.0"
    cmd += " --audio-copy-mask aac,ac3,dtshd,dts,mp3 --audio-fallback ffac3 -f mp4 -4"
    cmd += " -X 960 -Y 640 --loose-anamorphic --modulus 2 -m"
    cmd += " --x264-preset medium --h264-profile high --h264-level 4.1 -s 1 --subtitle-burned"
    puts cmd if debug
    puts`#{cmd}`
    seenHash["#{myhash}"] = true
    rio(@options.hashname) << "#{myhash}\n"
  }
  FileUtils.rm('runInProgress')
end

def do_pictures
  return nil if !@options.photoMode
  #no need to keep track of what we seen
  p 'starting photo mode' if @options.debug

  approve = [".jpeg", ".jpg","gif"]

  Find.find(@options.inputDir){|f|
    debug = @options.debug
    puts "checking #{f}" if debug
    next if File.directory?(f)
    next if !approve.any? {|g| f.downcase.include? g}
    pic = MiniExiftool.new f
    picDate = pic['DateTimeOriginal']
    if picDate == nil then
      puts "unable to get exif data for photo"
      next
    end
    p pic['orientation'] if debug
    p pic['DateTimeOriginal'] if debug
    pic_yr_mon_day = picDate.strftime("%Y.%m.%d")
    p "Exif Creation: #{pic_yr_mon_day}" if debug
    p "#{File.basename(f,".*")}" if debug
    outname = pic_yr_mon_day+" - "+File.basename(f)
    nestedDir = @options.outputDir+pic_yr_mon_day
    if !File.exist? nestedDir then
      Dir.mkdir nestedDir
    end
    outname = nestedDir+"/"+outname
    FileUtils.mv(File.path(f), outname)
  }
end

def test_handbrake
  return nil if File.exist?(@options.handbrake || 'null')
  @options.handbrake = "c:/Program Files (x86)/Handbrake/HandBrakeCLI.exe"
  return nil if File.exist?(@options.handbrake)
  @options.handbrake = 'c:/Program Files/Handbrake/HandBrakeCLI.exe'
  return nil if File.exist?(@options.handbrake)
  p "Unable to find handbrake, is installed?"
  exit 1
end

MiniExiftool.command = @options.exiftool
# Program technically starts here
opt_parse.parse!
test_handbrake
#semi hacky to only have one instance running
do_video
while (File.exist?('runRequested')) do
  FileUtils.rm('runRequested')
  do_video  
end

do_pictures
