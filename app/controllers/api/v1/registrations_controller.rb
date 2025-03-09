class Api::V1::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    token = current_token
    response.set_header('Authorization', "Bearer #{token}")
    render json: { user: resource, token: token }, status: :ok
  end

  def current_token
    request.env['warden-jwt_auth.token']
  end
end