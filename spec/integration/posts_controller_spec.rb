require 'spec_helper'

describe PostsController do
  let(:controller) {PostsController.new}
  let(:session) {{}}

  describe '#tracker' do
    before(:each) do
      SecureRandom.stubs(:uuid).returns('54321')

      controller.stubs(:session).returns(session)
    end

    it 'builds a new tracker' do
      tracker = controller.tracker

      expect(tracker.id).to eq('UA-1234-5')
      expect(tracker.client_id).to eq('54321')
    end

    it 'appends tracker to the notification payload' do
      payload = {}

      controller.append_info_to_payload(payload)

      expect(payload["staccato.tracker"]).to eq(controller.tracker)
    end
  end
end
