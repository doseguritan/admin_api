class Api::V1::SessionsController < Devise::SessionsController
  respond_to :json
  
  def destroy
    if current_user
      current_user.jwt_revoked!
      render json: {message: "Successfully signed out."}, status: :ok
    else
      render json: {message: 'No active session found.'}, status: :unprocessable_entity
    end
  end

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