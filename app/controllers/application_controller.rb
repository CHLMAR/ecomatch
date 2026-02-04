class ApplicationController < ActionController::Base

  def default_url_options
    { host: ENV["HOST_NAME"] || "localhost:3000" }
  end
end
