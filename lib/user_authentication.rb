module UserAuthentication
  def create_user params
    user = User.new(json_parse params['user'])
    user.role_id = Role.get_role_id('App User')
    user.save
    user
  end

  def sign_in params
    user_params = json_parse params['user']
    response, message = params_present?({email: [], password: []}, user_params)
    return {status: false, message: message} unless response
    user = User.select("id, email, first_name, last_name, authentication_token AS auth_token, confirmation_token, encrypted_password, is_active").find_by_email(user_params[:email])
    return {status: false, message: "User not found, Please check the email"} unless user
    return {status: false, message: "Email is not confirmed", user: user} if user.confirmation_token.present?
    return {status: false, message: "Your account is blocked, please contact CHOC Administrator", user: user} unless user.is_active
    if user.valid_password?(user_params[:password])
      upcoming_events = Event.select("id, event_date, name").where('is_permanent_event = ? && event_date >= ? ', false, Date.today).order("event_date, event_time ASC").limit(10)
      permanent_events = Event.select("id, name").where('is_permanent_event = ? ', true).limit(10)
      {status: true, user: user, upcoming_events: upcoming_events, permanent_events: permanent_events}
    else
      {status: false, message: "Incorrect Password"}
    end
  end

  def forgot_password params
    user_params = json_parse params['user']
    response, message = params_present?({email: []}, user_params)
    return {status: false, message: message} unless response
    user = User.select("id, email, first_name, last_name, authentication_token, reset_password_token, reset_password_sent_at, role_id").find_by_email(user_params[:email])
    if user
      user.send_reset_password_instructions
      {status: true, message: "The link to reset password has been sent to your email, please follow the link to reset password."}
    else
      {status: false, message: "User not found!"}
    end
  end

  def resend_confirmation_email params
    user_params = json_parse params['user']
    response, message = params_present?({email: []}, user_params)
    return {status: false, message: message} unless response
    user = User.select("id, first_name, last_name, email, authentication_token, confirmation_token, unconfirmed_email, role_id").where("confirmation_token IS NOT NULL").find_by_email(user_params[:email])
    if user
      user.send_confirmation_instructions
      {status: true, message: "The confirmation link has been resent to your email, please follow the link to confirm your account."}
    else
      {status: false, message: "User not found!"}
    end
  end
end