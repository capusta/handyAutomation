require 'open-uri'
require 'fileutils'

## To be modified
tools = {
	'imageMagic.exe' => 'http://www.imagemagick.org/download/binaries/ImageMagick-7.0.1-10-Q16-x64-dll.exe',
	'exiftool.zip' => 'http://www.sno.phy.queensu.ca/~phil/exiftool/exiftool-10.19.zip'
}
download_location = 'downloads'
FileUtils.mkdir(download_location) if !File.exist?(download_location)

tools.each { |name, weblocation| 
	save_location = "#{download_location}/#{name}"
	FileUtils.rm(save_location) if File.exist?(save_location)
	File.open(save_location,'wb') { |saved_file|
		saved_file.write open(weblocation,'rb').read
	}
}

