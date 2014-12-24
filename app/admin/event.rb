ActiveAdmin.register Event do
  menu :priority => 2
  config.filters = false

  index do
    column "Event Name", :name
    column "Releases" do |e|
      if e.patient_forms.count > 0
        link_to e.patient_forms.count, admin_event_path(e)
      else
        e.patient_forms.count
      end
    end
    column "Date" do |e|
      e.is_permanent_event ? 'Permanent' : e.event_date.present? ? e.event_date.strftime("%B %d, %Y") : ''
    end
    column "Action" do |resource|
      links = ''.html_safe
      if resource.patient_forms.count == 0
        links += link_to I18n.t('active_admin.edit'), edit_resource_path(resource), :class => "member_link edit_link"
        links += '| '
        links += link_to I18n.t('active_admin.delete'), resource_path(resource), :method => :delete, :confirm => I18n.t('active_admin.delete_confirmation'), :class => "member_link delete_link"
      end
      links
    end
  end

  show :name => :name do
    panel "Patients" do
      table_for event.patients do |e|
        e.column("Patient") { |p| p.display_name }
        e.column("Email Address") { |p| p.email }
        e.column("Action") do |resource|
          is_revoked = PatientForm.where("event_id = ? && patient_id = ?", params[:id], resource).pluck(:is_revoked).first
          links = ''.html_safe
          links += link_to "View", patient_details_admin_event_path(params[:id], :patient_id => resource)
          links += '&nbsp;&nbsp;|&nbsp;&nbsp;'.html_safe
          links += is_revoked ? "Revoked" : (link_to "Revoke", revoke_form_admin_event_path(params[:id], :patient_id => resource), :confirm => "Are you sure you want to revoke this release?")
          links
        end
      end
    end
  end

  controller do
    def create
      @event = Event.new(params[:event])
      if @event.save
        flash[:notice] = "Event successfully created"
        redirect_to :action => :index
      else
        render :action => :new
      end
    end

    def update
      @event = Event.find(params[:id])
      if @event.update_attributes(params[:event])
        flash[:notice] = "Event successfully updated"
        redirect_to :action => :index
      else
        render :action => :edit
      end
    end
  end

  member_action :patient_details do
    @event = Event.find(params[:id])
    @patient = Patient.find(params[:patient_id])
    @patient_form = PatientForm.where("event_id = ? && patient_id = ?", params[:id], params[:patient_id]).first
    use_ids = @patient_form.patient_form_uses.pluck(:use_id)
    @uses = []
    use_ids.each do |u|
      @uses << Use.find(u).description
    end
    @uses <<  @patient_form.other_purpose if @patient_form.other_purpose.present?
    @release = Release.find(@patient_form.release_id)
    @is_revoked = @patient_form.is_revoked
  end

  member_action :revoke_form do
    patientform = PatientForm.where("event_id = ? && patient_id = ?", params[:id], params[:patient_id]).first
    patientform.update_attribute(:is_revoked, true)
    redirect_to admin_event_path, :notice => "Revoked this release successfully !!!"
  end

  collection_action :patient_events do
    @patient = Patient.find(params[:patient_id])
    @patient_forms = PatientForm.where("patient_id = ?", params[:patient_id]).includes(:event)
  end

  collection_action :download do
    release_form, patient_form_id = Event.generate_pdf(:patient_form_id => params[:patient_form_id])
    send_data(release_form.pdf, :filename => "Release Form #{patient_form_id}",
              :type => 'application/pdf')
  end

  collection_action :search_results, :method => :get do
    @query = params[:q]
    @search_for = params[:searchFor]
    if @search_for == "event"
      @results = Event.metasearch(:name_contains => @query).relation
    else
      @results = Patient.joins(:patient_forms).where(["first_name LIKE ? or last_name LIKE ? or concat(first_name, ' ', last_name) like ? and is_revoked = ?", '%'+ @query + '%', '%'+ @query + '%','%'+ @query + '%', 0 ])
    end
  end

  collection_action :send_mail, :method => :get do
    patient_form = PatientForm.find_by_id(params[:id])
    UserMailer.delay.release_form_mail(patient_form, params[:email])
    redirect_to :back, :notice => "Sent mail successfully !!!"
  end

  form :html =>{:class => "customForm"} do |f|
    if f.object.new_record?
      f.inputs "New Event" do
        f.input :name
        f.input :event_date, :as => :string, :input_html => {:class => "hasDatePicker"}
        f.input :is_permanent_event, :label => 'No date for this Event'
        f.input :user_id, :label => 'User', :as => :hidden, :value => current_user.id
      end
    else
      f.inputs "Edit Event" do
        f.input :name
        f.input :event_date, :as => :string, :input_html => {:class => "hasDatePicker"}
        f.input :is_permanent_event, :label => 'No date for this Event'
      end
    end
    f.actions
  end
end