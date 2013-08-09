module Staccato
  module SessionTracking
    def tracker
      # load or set new uuid in session
      client_id = session['staccato.client_id'] ||= Staccato.build_client_id

      # pull tracker id from config
      tracker_id = Rails.configuration.staccato.tracker_id

      @tracker ||= Staccato.tracker(tracker_id, client_id)
    end

    def append_info_to_payload(payload)
      super

      payload["staccato.tracker"] = tracker
    end
  end
end
