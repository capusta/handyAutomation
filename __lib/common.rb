def checkDir(s)
  gracefulExit("#{s} is not a valid directory.") if !File.directory?(s || "")
  if s.include? "\\" then
    s << "\\" unless s[s.length-1] == "\\" #we are using windows
  else
    s << "/" unless s[s.length-1] == "/"   #we are using linux
  end
  debugLog("input directory #{s} is OK")
  s
end

def checkFile(s)
  gracefulExit("File #{s} does not exist") if !File.exist?(s || "")
  debugLog("File #{s} is OK")
  s
end

def gracefulExit(msg)
  puts <<EOF
  
  Error: #{msg}
  -- Exiting --
EOF
  exit
end

def debugLog(msg)
  puts "debug: #{msg}" if @options.debug
end