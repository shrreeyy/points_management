# Included ActionController::HttpAuthentication::Basic::ControllerMethods for 'authenticate_or_request_with_http_basic' usage
# Since this is an API app, we prefer manual decoding using this helper over full ActionController::Base functionality

class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  before_action :authenticate_user!

  rescue_from ActionController::ParameterMissing, with: :parameter_missing

  def render_error(errors, status = :unprocessable_entity)
    render json: { errors: errors }, status: status
  end

  private

  def authenticate_user!
    authenticate_or_request_with_http_basic do |username, password|
      current_user = User.find_by(email: username)
      current_user&.authenticate(password)
    end
  end

  def parameter_missing(exception)
    render_error("Parameter missing: #{exception.param}", status = :unprocessable_entity)
  end

  # Including here, As this is in use in multiple controllers
  def configuration
    @configuration ||= ::Configuration.current
  end
end
