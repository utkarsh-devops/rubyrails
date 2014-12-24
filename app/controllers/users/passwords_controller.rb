class Users::PasswordsController < Devise::PasswordsController
  def edit
    self.resource = resource_class.find_or_initialize_with_error_by(:reset_password_token, params[:reset_password_token])
    if !resource.errors.empty?
      flash[:alert] = "Password token is invalid"
      redirect_to new_session_path(resource_name)
    end
  end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      flash[:notice] = "Your password was changed successfully."
      after_resetting_password_path_for(resource)
    else
      respond_with resource
    end
  end

  protected
    def after_resetting_password_path_for(resource)
      logger.info "after_resetting_password_path_for"
      if resource.is_admin?
        redirect_to new_session_path(resource)
      else
        redirect_to reset_password_users_path
      end
    end
end
