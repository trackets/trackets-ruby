# Trackets

WIP gem for Trackets.com service

## Installation

Add this line to your application's Gemfile:

    gem 'trackets'

And then execute:

    $ bundle

## Usage

    $ rails g trackets:install API_KEY

## Rails

To include JavaScript tracking code in your app just add this line to your `app/views/layout/application.html.erb`

```erb
<%= trackets_include_tag %>
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/trackets/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
