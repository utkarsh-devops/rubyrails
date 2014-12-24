class Users::RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
    @user = User.new(params[:user])
    @user.role_id = Role.get_role_id("Admin User")
    @user.is_app_user = false

    if @user.save
      flash[:notice] = "You have signed up successfully. A confirmation was sent to your e-mail."
      redirect_to root_url
    else
      render :action => :new
    end
  end
end