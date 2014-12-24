ActiveAdmin.register User, :as => "App Users" do
  menu :label => "App Users", :priority => 4
  actions :all, except: [:edit, :update, :destroy]
  config.clear_action_items!
  config.filters = false

  scope :app_users, :show_count => false
  controller do
    def scoped_collection
      User.app_users
    end
  end

  index do
    column "Users"  do |p|
        p.first_name+" "+ p.last_name
    end
    column "Releases" do |rel|
      if PatientForm.where("user_id = ?", rel.id).count > 0
        link_to PatientForm.where("user_id = ?", rel.id).count, admin_app_user_path(rel)
      else
        PatientForm.where("user_id = ?", rel.id).count
      end
    end
    column "Email Address", :email
    column "Action" do |resource|
      links = ''.html_safe
      links += resource.is_admin? ? raw("&nbsp; &nbsp; Admin &nbsp; &nbsp; &nbsp;") : (link_to "Make Admin", make_admin_admin_app_user_path(resource))
      links += ' | '
      links += link_to resource.is_active ? "De-Activate" : "Activate", toggle_activate_admin_app_user_path(resource)
      links
    end
  end

  member_action :make_admin do
    user = User.find(params[:id])
    user.update_attribute(:role_id, Role.get_role_id("Admin User"))
    UserMailer.delay.make_admin_mail(user)
    redirect_to admin_app_users_path, :notice => "Becomes Admin Successfully !!!"
  end

  member_action :toggle_activate do
    user = User.find(params[:id])
    before_value = user.is_active
    user.update_attribute(:is_active, !before_value)
    if before_value
      UserMailer.delay.block_user_mail(user)
    else
      UserMailer.delay.activate_user_mail(user)
    end
    redirect_to admin_app_users_path, :notice => before_value ?  "Account has been blocked !!!"  : "Account is reactivated !!!"
  end

  show :name => :name do
    panel "Patients" do
      table_for patient_events_ids = PatientForm.where("user_id = ?", params[:id]).select("id, patient_id, event_id").includes(:patient, :event).select("patient_id, event_id") do |t|
        t.column("Patient") { |p| p.patient.first_name+" "+ p.patient.last_name}
        t.column("Email Address") { |p| p.patient.email }
        t.column("Event Name"){|p| p.event.name}
        t.column("Action") do |p|
          links = ''.html_safe
          links += link_to "View", patient_details_admin_event_path(p.event.id, :patient_id => p.patient.id)
          links
        end
      end
    end
  end
end