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

  describe "tracking exceptions" do
    let(:tracker) {stub(:exception)}

    before(:each) do
      controller.stubs(:tracker).returns(tracker)
    end

    it 'still raises the error' do
      expect { controller.destroy }.to raise_exception(NotImplementedError)
    end

    it 'tracks the error' do
      controller.track_exception_with_staccato(NotImplementedError.new)

      expect(tracker).to have_received(:exception).with(description: 'NotImplementedError')
    end

    it 'tracks the error and raises' do
      expect { 
        controller.track_exception_with_staccato_and_raise(NotImplementedError.new)
      }.to raise_exception(NotImplementedError)

      expect(tracker).to have_received(:exception).with(description: 'NotImplementedError')
    end
  end
end
