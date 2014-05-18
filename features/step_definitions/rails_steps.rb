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
  define_controller_action_to(controller_and_action, code)
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
  step "I run `rails r script.rb`"
end

Then(/^I should receive notification to Trackets server$/) do
  expect(requests.size).to be > 0
end

Then(/^last notice params should (?:(not ))?contain "(.*?)"$/) do |negator, string|
  if negator
    last_notice_serialized_data.should_not match string
  else
    last_notice_serialized_data.should match string
  end
end

Then(/^last notice params for key "(.*?)" is "(.*?)"$/) do |key, val|
  last_notice_params_for(key).should eq val
end
