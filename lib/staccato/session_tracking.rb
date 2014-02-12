module Staccato
  module SessionTracking
    def tracker
      @tracker ||= Staccato.tracker(staccato_tracker_id, staccato_client_id)
    end

    # pull tracker id from config
    def staccato_tracker_id
      Rails.configuration.staccato.tracker_id
    end

    # load or set new uuid in session
    def staccato_client_id
      session['staccato.client_id'] ||= Staccato.build_client_id
    end

    def append_info_to_payload(payload)
      super

      payload["staccato.tracker"] = tracker
    end
  end
end
