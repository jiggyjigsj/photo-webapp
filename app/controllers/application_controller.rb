require "google/cloud/storage"

class ApplicationController < ActionController::Base
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  helper_method :current_user

  def authenticate_user!
   redirect_to '/login' unless current_user
  end

  def gcp_cloud_storage(bucket)
    begin
      storage = Google::Cloud::Storage.new(
        project_id: ENV.fetch("GCP_PROJECT_ID"),
        credentials: ENV.fetch("GCP_CREDENTIALS_FILE")
      )
      storage.bucket bucket
    rescue => e
      raise "Looks like your bucket doesn't exists or your credentials are wrong!"
    end
  end
end
