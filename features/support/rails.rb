module RailsHelpers
  def requests
    path = File.join(@dirs, "request_log.txt")

    if File.exist?(path)
      File.foreach(path).map { |l| JSON.parse(l) }
    else
      []
    end
  end
end

World(RailsHelpers)
