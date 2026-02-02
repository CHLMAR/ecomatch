# frozen_string_literal: true

# SearchChannel handles WebSocket connections for real-time search updates.
# When a user submits a search, they subscribe to this channel to receive
# Turbo Stream updates when the background job completes.
#
# Example subscription from JavaScript:
#   consumer.subscriptions.create({ channel: "SearchChannel", search_id: 123 })
#
class SearchChannel < ApplicationCable::Channel
  def subscribed
    # Find the search and create a unique stream for it
    search = Search.find(params[:search_id])

    # stream_for creates a stream unique to this search record
    # When we broadcast to this search, only subscribers to this stream receive it
    stream_for search
  end

  def unsubscribed
    # Cleanup when channel is unsubscribed (optional)
    # Rails handles this automatically for most cases
  end
end
