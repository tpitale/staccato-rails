module Staccato
  module Subscribers
    class Page
      def self.call(*args)
        new(args).track!
      end

      def initialize(args)
        @args = args
      end

      def get?
        payload[:method] == "GET"
      end

      def path
        path_prefix + payload[:path]
      end

      def hostname
        Rails.configuration.staccato.hostname
      end

      def track!
        return if controller_disabled?
        return unless get?
        tracker.pageview(context.merge(path: path, hostname: hostname))
      end

      private

      def event
        @event ||= ActiveSupport::Notifications::Event.new(*@args)
      end

      def payload
        @payload ||= event.payload
      end

      def tracker
        @tracker ||= payload['staccato.tracker']
      end

      def context
        @context ||= payload['staccato.context']
      end

      def path_prefix
        Rails.application.config.staccato.pageview_prefix.to_s
      end

      def controller
        payload[:controller].safe_constantize
      end

      def controller_disabled?
        !controller.nil? &&
          controller.respond_to?(:staccato_page_disabled?) &&
          controller.staccato_page_disabled?
      end
    end
  end
end
