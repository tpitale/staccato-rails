module Staccato
  module ExceptionTracking

    def self.included(controller)
      controller.rescue_from ::Exception,
        with: :track_exception_with_staccato_and_raise
    end

    def track_exception_with_staccato(exception)
      tracker.exception(description: exception.class.name)
    end

    def track_exception_with_staccato_and_raise(exception)
      track_exception_with_staccato(exception)

      # re-raise the exception as normal
      raise exception
    end
  end
end
