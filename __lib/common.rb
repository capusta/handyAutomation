def checkDir(s)
  gracefulExit("#{s} is not a valid directory.") if !File.directory?(s || "")
  s << "/" unless s[s.length-1] == "/"
  debugLog("input directory #{s} is OK")
  s
end

def checkFile(s)
  gracefulExit("File #{s} does not exist") if !File.file?(s || "")
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