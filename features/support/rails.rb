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

  def define_controller_action_to(controller_and_action, code)
    controller, action = controller_and_action.split("#")

    File.open(File.join(@dirs, "app", "controllers", "#{controller}_controller.rb"), "w") do |f|
      f.puts "class #{controller.classify}Controller < ApplicationController"
      f.puts "  def #{action}"
      f.puts code
      f.puts "  end"
      f.puts "end"
    end
  end

end

World(RailsHelpers)
