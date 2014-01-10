module Staccato
  class Railtie < Rails::Railtie
    config.before_configuration do |app|
      app.config.staccato = ActiveSupport::OrderedOptions.new
    end

    initializer "staccato.controller_extension" do
      ActiveSupport.on_load(:action_controller) do
        include Staccato::SessionTracking
      end
    end

    initializer "staccato.configure_subscribers" do
      ActiveSupport::Notifications.subscribe('process_action.action_controller', Staccato::Subscribers::Page)
      ActiveSupport::Notifications.subscribe('process_action.action_controller', Staccato::Subscribers::Timing)
    end
  end
end
