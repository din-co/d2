class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # We include intercom on our own
  skip_after_filter :intercom_rails_auto_include

  private

  # Add extra information to log events for lograge.
  def append_info_to_payload(payload)
    super
    payload[:remote_ip] = request.remote_ip
    payload[:request_id] = request.uuid
  end
end
