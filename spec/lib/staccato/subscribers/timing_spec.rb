require 'spec_helper'

describe Staccato::Subscribers::Timing do

  let(:tracker) { Staccato.tracker(nil) }
  let(:now) {Time.now.to_i}
  let(:duration) {49} # in seconds

  let(:payload) {
    # args example from:
    # http://edgeguides.rubyonrails.org/active_support_instrumentation.html#process-action-action-controller
    {
      controller: "PostsController",
      action: "index",
      params: {"action" => "index", "controller" => "posts"},
      format: :html,
      path: "/posts",
      method: "GET",
      status: 200,
      view_runtime: 46.848, # milliseconds
      db_runtime: 0.157, # milliseconds
      'staccato.tracker' => tracker
    }
  }

  let(:args) {
    [
      "process_action.action_controller", # name
      now - duration, # starting
      now, # ending
      SecureRandom.uuid, # transaction_id
      payload
    ]
  }

  let(:timing) {Staccato::Subscribers::Timing.new(args)}

  before(:each) do
    tracker.stubs(:timing)
    timing.track!
  end

  it 'tracks total run time' do
    # convert duration time to milliseconds
    total_runtime = duration.to_f*1000
    expect(tracker).to have_received(:timing).with(category: :rails, variable: :runtime, label: :total, time: total_runtime)
  end

  it 'tracks db run time' do
    expect(tracker).to have_received(:timing).with(category: :rails, variable: :runtime, label: :db, time: 0.157)
  end

  it 'tracks view rendering run time' do
    expect(tracker).to have_received(:timing).with(category: :rails, variable: :runtime, label: :view, time: 46.848)
  end
end