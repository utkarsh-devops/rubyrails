class Api::V1::UsersController < ApiController
  respond_to :json

  skip_before_filter :verify_authenticity_token, :if => Proc.new{ |c| c.request.format == 'application/json' }
  skip_before_filter :authentic_user

  def create
    user = User.create_user(params)
    render json:(user.errors.any? ? {status: false, message: user.errors.full_messages.join(", ")}.to_json : {status: true, message: "Mail has been sent to your inbox for confirmation of account"}.to_json)
  end
end
