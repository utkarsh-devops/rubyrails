ActiveAdmin.register User, :as => "Admin Users" do
  menu :label => "Admin Users", :priority => 5
  actions :all, except: [:edit, :update, :destroy]
  config.filters = false

  scope :admin_users, :show_count => false
  controller do
    def scoped_collection
      User.admin_users
    end

    def create
      @admin_users = User.new(params[:admin_users])
      @admin_users.role_id = Role.get_role_id("Admin User")
      @admin_users.is_app_user = false

      if @admin_users.save
        flash[:notice] = "Admin created and confirmation link has been sent to e-mail."
        redirect_to action: :index
      else
        render action: :new
      end
    end
  end

  index do
    column "Email Address", :email
    column "Last Login", :last_sign_in_at
    column "Action" do |resource|
      links = ''.html_safe
      links += link_to 'Delete', delete_admin_user_admin_admin_user_path(resource)
      links
    end
  end

  form :url => "/admin/admin_users", :html =>{:class => "customForm"} do |f|
    f.inputs "Admin User Details" do
      f.input :email
    end
    f.actions do
      f.action :submit, :label => "Submit"
    end
  end

  member_action :delete_admin_user do
    user = User.find(params[:id])
    if user.is_app_user
      user.update_attribute(:role_id, Role.get_role_id("App User"))
    else
      user.update_attribute(:is_deleted, true)
    end
    redirect_to admin_admin_users_path, :notice => "Admin user deleted Successfully !!!"
  end
end