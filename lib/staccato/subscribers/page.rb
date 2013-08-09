module Staccato
  module Subscribers
    class Page
      def self.call(*args)
        new(args).track!
      end

      def get?
        payload[:method] == "GET"
      end

      def path
        payload[:path]
      end

      def hostname
        Rails.configuration.staccato.hostname
      end

      def track!
        return unless get?
        tracker.pageview(path: path, hostname: hostname)
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
    end
  end
end
