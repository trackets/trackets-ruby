module RailsHelpers

  def requests
    path = File.join(@dirs, "request_log.txt")

    if File.exist?(path)
      File.foreach(path).map { |l| JSON.parse(l) }
    else
      []
    end
  end

  def last_notice
    requests.last
  end

  def last_notice_serialized_data
    last_notice["rack.input"].first
  end

  def last_notice_form_data
    CGI::parse(last_notice_serialized_data)
  end

  def last_notice_params_for(key)
    last_notice_form_data["error[params][#{key}]"].first
  end
  
end

World(RailsHelpers)
