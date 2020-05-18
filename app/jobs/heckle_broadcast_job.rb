class HeckleBroadcastJob < ApplicationJob
  queue_as :default

  def perform(heckle)
    compute_channels(heckle).each do |channel|
      ActionCable.server.broadcast channel, {heckle: render_heckle(heckle)}
    end
  end

  private

  DEFAULT_CHANNEL = "forum_channel".freeze

  def compute_channels(heckle)
    # ActionCable.server.broadcast() takes a channel as a string, and
    # #broadcasting_for() takes a model and returns a string unique to that model.
    # So, we have one static string ("forum_channel") for the shared channel and a
    # User-instance-specific channel to which each listener is subscribed on the
    # client side.
    channels = heckle.targets.map do |t|
      t.private_channel
    end
    channels << DEFAULT_CHANNEL if channels.empty?
    channels
  end

  def render_heckle(heckle)
    ApplicationController.renderer.render partial: 'heckles/heckle',
                                          locals: { heckle: heckle }
  end
end
