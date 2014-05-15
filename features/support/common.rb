module CommonHelpers
  def replace_in_file(path, from, to)
    File.open(path, "r+") do |f|
      newstr = f.read.sub(from, to)
      f.rewind
      f.write(newstr)
    end
  end
end

World(CommonHelpers)
