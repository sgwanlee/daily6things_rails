class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  after_filter :discard_flash_when_ajax_request

  def json_for(target, options = {})
    target.active_model_serializer.new(target).to_json
  end

  private
    def discard_flash_when_ajax_request
      return unless request.xhr?
      flash.discard # don't want the flash to appear when you reload page
    end
end
