class Users::ConfirmationsController < Devise::ConfirmationsController

  # show password form if resource is admin otherwise directly confirm the appuser
  def show
      self.resource = resource_class.find_by_confirmation_token(params[:confirmation_token]) if params[:confirmation_token].present?
      super if resource.nil? or resource.confirmed? or !resource.is_admin?
  end

  # only admin will come here to confirm his email and
  # associate password to newly confirm account
  def confirm
    self.resource = resource_class.find_by_confirmation_token(params[resource_name][:confirmation_token]) if params[resource_name][:confirmation_token].present?
    if resource.update_attributes(params[resource_name].except(:confirmation_token)) && resource.password_match?
      self.resource = resource_class.confirm_by_token(params[resource_name][:confirmation_token])
      flash[:notice] = "Thank you for verifying your account."
      sign_in_and_redirect(resource_name, resource)
    else
      render :action => "show"
    end
  end

  protected

    # The path used after confirmation.
    def after_confirmation_path_for(resource_name, resource)
      if resource.is_a?(User) && resource.is_admin? && resource.is_deleted == false
        admin_dashboard_path
      else
        sign_out(current_user)
        app_admin_confirm_users_path
      end
    end
end