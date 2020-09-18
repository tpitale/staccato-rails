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

Session UUID for the `client_id` is handled for you. Can be overridden easily, see [Overriding the client_id](#overriding-the-client_id).

## Usage ##

### Configuration ###

In **environments/production.rb** (leave blank in development/test to not track):

```ruby
config.staccato.tracker_id = 'UA-XXXX-Y'
config.staccato.hostname = 'domain.com' # optional, but recommended
```

**Note:** Because this is a Rails-specific gem, we leverage Rails' method of configuration. As such configuration should be placed in the appropriate environment file, specifically `production.rb`. It is _ill-advised_ to configure in Development or Test environments as that may cause false tracking during local work.

### Tracking ###

In controllers, `tracker` is made available to you:

```ruby
tracker.event(category: 'video', action: 'play', label: 'cars', value: 1)
```

Note: if you have an existing method named `tracker`, this is also available with the more verbose `staccato_tracker`.

## Overriding the client_id ##

A method is added to your controller called `staccato_client_id`. By default, it's implementation looks like:

```ruby
session['staccato.client_id'] ||= Staccato.build_client_id
```

If you wish to not store the `client_id` in session, or you wish to use another UUID value, you may override the method `staccato_client_id` as you see fit. Make sure that the `client_id` you generate fits with Google Analytics requirements. It _must_ remain the same `client_id` for an individual user's "session" (by GA standards) if you wish to track a user as they move through your application.

## Setting a pageview prefix ##

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

## Disable tracking for a controller

You can disable tracking of a specific controller by adding a class method.

```ruby
class SomeController
  def self.staccato_page_disabled?; true; end
  def self.staccato_timing_disabled?; true; end
end
```

## Adding Global and Hit context ##

To add values like `user_ip` to all hits called by `tracker` (in both your own code, and staccato-rails) create a method `global_context` in your controller and return a hash:

```ruby
def global_context
  {
    user_ip: request.remote_ip
  }
end
```

To add values only to the hits sent by staccato-rails (but not your own use of `tracker`) for pageviews and timing create a method `hit_context` in your controller and return a hash:

```ruby
def hit_context
  {
    user_agent: "cURL"
  }
end
```

If per-action control over the hits sent to GA is required you're better off just using `Staccato` directly at this point.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
