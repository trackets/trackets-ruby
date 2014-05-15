require 'active_support/core_ext/string/inflections'

Given(/^I'm in a new Rails application named "(.*?)"$/) do |app_name|
  step "I successfully run `rails new #{app_name} --skip-gemfile -O -T`"
  step %{I cd to "#{app_name}"}
  @app_name = app_name
end

When(/^I configure an app to use Trackets$/) do
  step %{I copy "trackets_interceptor.rb" to apps "config/initializers"}
  step "I successfully run `rails g trackets:install my-api-key`"

  additions =<<-EOS
    config.api_url = "http://trackets.com"
  EOS

  replace_in_file(File.join(@dirs, "config", "initializers", "trackets.rb"), /^end$/, "#{additions}\nend")
end

When(/^I copy "(.*?)" to apps "(.*?)"$/) do |template_name, target_path|
  template = File.join(TEMPLATES_DIR, template_name)
  target = File.join(@dirs, target_path)

  FileUtils.cp(template, target)
end

When(/^I define action "(.*?)" to$/) do |controller_and_action, code|
  controller, action = controller_and_action.split("#")

  File.open(File.join(@dirs, "app", "controllers", "#{controller}_controller.rb"), "w") do |f|
    f.puts "class #{controller.classify}Controller < ApplicationController"
    f.puts "  def #{action}"
    f.puts code
    f.puts "  end"
    f.puts "end"
  end
end

When(/^I define route "(.*?)" to "(.*?)"$/) do |route, target|
  route_definition = %{get "#{route}", to: "#{target}"}
  replace_in_file(File.join(@dirs, "config", "routes.rb"), /^end$/, "#{route_definition}\nend")
end

When(/^I request "(.*?)"$/) do |url|
  script =<<-EOS
  require File.expand_path('../config/environment', __FILE__)

  env = Rack::MockRequest.env_for(#{url.inspect})
  p #{@app_name.classify}::Application.call(env)
  EOS

  File.open(File.join(@dirs, "script.rb"), "w") { |f| f.write(script) }
  p step "I run `rails r script.rb`"
end

Then(/^I should receive notification to Trackets server$/) do
  expect(requests.size).to be > 0
end
