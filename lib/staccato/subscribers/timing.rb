module Staccato
  module Subscribers
    class Timing
      def self.call(*args)
        new(args).track!
      end

      def initialize(args)
        @args = args
      end

      def total_runtime
        @total_runtime ||= event.duration
      end

      def db_runtime
        @db_runtime ||= payload[:db_runtime]
      end

      def view_runtime
        @view_runtime ||= payload[:view_runtime]
      end

      def times
        [
          {label: :total, time: total_runtime},
          {label: :db, time: db_runtime},
          {label: :view, time: view_runtime}
        ]
      end

      def track!
        params = context.merge(category: :rails, variable: :runtime)

        times.each do |time|
          tracker.timing(params.merge(time))
        end
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
    end
  end
end
