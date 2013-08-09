# Staccato::Rails

Provides seamless integration with basic tracking of rails (timing and pageviews)
into the Google Analytics Measurement API.

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
* TODO: Exception tracking (exception name, fatal if 500 error)

Session UUID for the client_id is handled for you. Can be overridden easily.

## Usage

In environments/production.rb (leave blank in development/test to not track):

    config.staccato.tracker_id = 'UA-XXXX-Y'
    config.staccato.hostname = 'domain.com' # optional, but recommended

In controllers, `tracker` is made available to you:

    tracker.event(category: 'video', action: 'play', label: 'cars', value: 1)

## Disable some, or all, tracking (TODO)

    config.staccato.timing = false
    config.staccato.pageviews = false
    config.staccato.exceptions = false

## Setting a pageview prefix (TODO)

    config.staccato.pageview_prefix = '/staccato'

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
