# Staccato::Rails

Provides seamless integration with basic tracking of rails (timing and pageviews) into the Google Analytics Measurement API.

[![Build Status](https://travis-ci.org/tpitale/staccato-rails.png?branch=master)](https://travis-ci.org/tpitale/staccato-rails)
[![Code Climate](https://codeclimate.com/github/tpitale/staccato-rails.png)](https://codeclimate.com/github/tpitale/staccato-rails)

## Installation

Add this line to your application's Gemfile:

    gem 'staccato-rails'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install staccato-rails

## Provides

* Timing from instrumentation (total duration, db_runtime, view_runtime)
* Pageview tracking on GETs
* Event tracking hooks in controllers, models that use the request session client id
* Exception tracking (tracks only the exception name)

Session UUID for the `client_id` is handled for you. Can be overridden easily.

## Usage

In environments/production.rb (leave blank in development/test to not track):

```ruby
config.staccato.tracker_id = 'UA-XXXX-Y'
config.staccato.hostname = 'domain.com' # optional, but recommended
```

In controllers, `tracker` is made available to you:

```ruby
tracker.event(category: 'video', action: 'play', label: 'cars', value: 1)
```

## Setting a pageview prefix

```ruby
config.staccato.pageview_prefix = '/staccato'
```

## Tracking exceptions ##

```ruby
config.staccato.exceptions = true
```

Tracking exceptions happens by adding to `ActionController::Base` a `rescue_from` for Exception. Because of this, it will only rescue exceptions that have not already been rescued from in your own code. If you wish to track those exceptions, as well, you can call `track_exception_with_staccato(exception)` to your own `rescue_from` methods.

## Disable some, or all, tracking

Inside of your `environment` files, as appropriate

```ruby
config.staccato.timing = false
config.staccato.pageviews = false
config.staccato.exceptions = false # default
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
