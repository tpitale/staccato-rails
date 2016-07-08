require "action_controller/railtie"

# Load Staccato Rails
require File.expand_path('../../../../../lib/staccato-rails', __FILE__)

module Dummy
  class Application < Rails::Application
    config.root = File.expand_path('../../', __FILE__)
  end
end

Dummy::Application.initialize!