class ApiController < ApplicationController
  respond_to :json

  before_filter :check_request
  before_filter :authentic_user

  def check_request
    response = ApiAuthentication.is_response_authenticated?(params)
    unless response[0]
      render json: response[1], status: 302
    end
  end

  def authentic_user
    user = User.find_by_id_and_authentication_token(params[:user_id], params[:auth_token])
    render json: {status: false, message: "User is not authenticated"}.to_json if user.nil?
  end
end