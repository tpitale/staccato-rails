require 'spec_helper'

describe Staccato::Subscribers::Page do

  let(:tracker) { Staccato.tracker(nil) }
  let(:context) { {} }
  let(:now) {Time.now.to_i}
  let(:duration) {49}

  let(:payload) {
    # args example from:
    # http://edgeguides.rubyonrails.org/active_support_instrumentation.html#process-action-action-controller
    {
      controller: "PostsController",
      action: "index",
      params: {"action" => "index", "controller" => "posts"},
      format: :html,
      path: "/posts",
      status: 200,
      view_runtime: 46.848,
      db_runtime: 0.157,
      'staccato.tracker' => tracker,
      'staccato.context' => context
    }
  }

  context "on a GET request" do
    let(:args) {
      [
        "process_action.action_controller", # name
        now - duration, # starting
        now, # ending
        SecureRandom.uuid, # transaction_id
        payload.merge(method: "GET")
      ]
    }

    let(:page) {Staccato::Subscribers::Page.new(args)}

    before(:each) do
      tracker.stubs(:pageview)
      page.track!
    end

    it 'tracks a pageview to google analytics' do
      expect(tracker).to have_received(:pageview).with(path: '/posts', hostname: 'domain.com')
    end
  end

  context "on a non-GET request" do
    let(:args) {
      [
        "process_action.action_controller", # name
        now - duration, # starting
        now, # ending
        SecureRandom.uuid, # transaction_id
        payload.merge(method: "POST")
      ]
    }

    let(:page) {Staccato::Subscribers::Page.new(args)}

    before(:each) do
      tracker.stubs(:pageview)
      page.track!
    end

    it 'tracks no pageviews to google analytics' do
      expect(tracker).to have_received(:pageview).never
    end
  end

  context "with a disabled controller" do
    let(:args) {
      [
        "process_action.action_controller", # name
        now - duration, # starting
        now, # ending
        SecureRandom.uuid, # transaction_id
        payload.merge(controller: "DisabledController")
      ]
    }

    let(:page) {Staccato::Subscribers::Page.new(args)}

    before(:each) do
      tracker.stubs(:pageview)
      page.track!
    end

    it 'tracks no pageviews to google analytics' do
      expect(tracker).to have_received(:pageview).never
    end
  end
end
