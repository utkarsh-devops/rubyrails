class ApplicationController < ActionController::Base
  protect_from_forgery
  #before_filter :authenticate_admin_user!

  def authenticate_admin_user!
    authenticate_user!
    unless current_user.try(:is_admin?)
      flash[:alert] = "Only Admin can login to this site."
      redirect_to root_path
    end
    #redirect_to new_user_session_path unless current_user.try(:is_admin?)
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) ||
      if resource.is_a?(User) && resource.is_admin? && resource.is_deleted == false
        admin_dashboard_path
      else
        sign_out(current_user)
        flash[:alert] = "Only Admin can login to this site."
        super
      end
  end
end
