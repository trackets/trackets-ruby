# Trackets

WIP gem for Trackets.com service

## Installation

Add this line to your application's Gemfile:

    gem 'trackets'

And then execute:

    $ bundle

## Usage

    $ rails g trackets:install API_KEY
    $ rake trackets:test # To send testing exception

## Rails

To include JavaScript tracking code in your app just add this line to your `app/views/layout/application.html.erb`

```erb
<%= trackets_include_tag %>
```

## Rack

Simple `example.ru`

```ruby
require 'rack'
require 'trackets'

Trackets.setup do |config|
  config.api_key = "insert-valid-api-key"
end

app = Rack::Builder.app do
  run lambda { |env| raise "Testing Error" }
end

use Trackets::Middleware::RackExceptionHandler
run app
```

## Rake tasks
    $ rake trackets:notify MESSAGE="Custom message from Rake"

## Contributing

1. Fork it ( https://github.com/[my-github-username]/trackets/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
