class Api::V1::UserAuthsController < ApiController
  respond_to :json

  skip_before_filter :authentic_user

  def sign_in
    response = User.sign_in(params)
    render json: response.to_json
  end

  def forgot_password
    response = User.forgot_password(params)
    render json: response.to_json
  end

  def resend_confirmation_email
    response = User.resend_confirmation_email(params)
    render json: response.to_json
  end
end