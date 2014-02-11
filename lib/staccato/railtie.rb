module Staccato
  class Railtie < Rails::Railtie
    config.before_configuration do |app|
      app.config.staccato = ActiveSupport::OrderedOptions.new

      # set defaults
      app.config.staccato.timing = true
      app.config.staccato.pageviews = true
      app.config.staccato.pageview_prefix = ""
    end

    initializer "staccato.controller_extension" do
      ActiveSupport.on_load(:action_controller) do
        include Staccato::SessionTracking
      end
    end

    initializer "staccato.configure_subscribers" do
      if config.staccato.timing
        ActiveSupport::Notifications.subscribe('process_action.action_controller', Staccato::Subscribers::Timing)
      end

      if config.staccato.pageviews
        ActiveSupport::Notifications.subscribe('process_action.action_controller', Staccato::Subscribers::Page)
      end
    end
  end
end
