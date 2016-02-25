begin
  require 'rinruby'
rescue
  `gem install rinruby`
end

class Rubystats

  def initialize csvPath
    #newpath = csvPath.gsub!("\\","\\\\\\\\").to_s
    #R.eval "fileName <- '#{newpath}'"
    # This seems a big buggy on windows
    # //TODO: Debug this one windows
    R.eval "fileName <- '#{csvPath}'"
    R.eval "source('_05finance/_analyze.R')"
    self
  end
end
