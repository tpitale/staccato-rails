module Staccato
  class Railtie < Rails::Railtie
    config.before_configuration do |app|
      app.config.staccato = ActiveSupport::OrderedOptions.new

      # set defaults
      app.config.staccato.timing = true
      app.config.staccato.pageviews = true
      app.config.staccato.pageview_prefix = ""
      app.config.staccato.exceptions = false
    end

    initializer "staccato.controller_extension" do
      track_exceptions = config.staccato.exceptions

      ActiveSupport.on_load(:action_controller) do
        include Staccato::SessionTracking

        include Staccato::ExceptionTracking if track_exceptions
      end
    end

    initializer "staccato.configure_subscribers" do
      config.after_initialize do
        if config.staccato.timing
          ActiveSupport::Notifications.subscribe('process_action.action_controller', Staccato::Subscribers::Timing)
        end

        if config.staccato.pageviews
          ActiveSupport::Notifications.subscribe('process_action.action_controller', Staccato::Subscribers::Page)
        end
      end
    end
  end
end
