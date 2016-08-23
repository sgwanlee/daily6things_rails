class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def json_for(target, options = {})
    target.active_model_serializer.new(target).to_json
  end
end
