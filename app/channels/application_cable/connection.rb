# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    # identified_by creates an accessor that will be available in all channels
    # This lets us know which user is connected via WebSocket
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      # Devise stores the user in warden - we can access it from the request env
      # This works because ActionCable shares the same session as the main app
      if verified_user = env["warden"]&.user
        verified_user
      else
        # Reject the connection if no authenticated user found
        # This prevents unauthenticated WebSocket connections
        reject_unauthorized_connection
      end
    end
  end
end
