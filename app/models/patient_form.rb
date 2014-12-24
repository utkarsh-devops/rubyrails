class PatientForm < ActiveRecord::Base
  belongs_to :release
  belongs_to :event
  belongs_to :patient
  belongs_to :user
  has_many :patient_form_uses
  has_many :uses, :through => :patient_form_uses

  extend ApiHelper

  attr_accessible :expiry_date, :follow_up_requested, :guardian_first_name, :guardian_last_name, :notes, :other_purpose, :profile_image, :sign_image, :release_id, :event_id, :user_id

  # Validations
  validates_inclusion_of :follow_up_requested, :in => [true, false]
  validates :release_id, :event_id, presence: true

  validate :valid_follow_up_field
  validate :valid_expiry_date
  validate :valid_event_id
  validate :valid_release_id

  #Carrierwave uploaders for image fields
  mount_uploader :profile_image, ProfileImageUploader
  mount_uploader :sign_image, SignImageUploader

  def self.create_form params
    response, message = params_present?({patient: [], patient_form: [], purpose_ids: [], user_id: []}, params)
    return {status: false, message: message} unless response
    begin
      transaction do
        # create or update patient
        patient_params = json_parse params['patient']
        patient = Patient.find_by_first_name_and_last_name_and_birth_date( patient_params[:first_name],
                                                                           patient_params[:last_name],
                                                                           patient_params[:birth_date]
                                                                          )
        if patient.nil?
          patient = Patient.create!(patient_params)
        else
          patient.update_attributes!(patient_params)
        end
        return {status: false, message: patient.errors.full_messages.join(", ")} if patient.errors.any?

        # register patient for event
        patient_form_params = json_parse params['patient_form']
        return {status: false, message: "Patient is already registered for this event"} if PatientForm.where("event_id = ? && patient_id = ?", patient_form_params[:event_id], patient.id).present?
        patient_form = patient.patient_forms.create!(patient_form_params)
        patient_form.user_id = params[:user_id] if User.exists?(params[:user_id])
        return {status: false, message: patient_form.errors.full_messages.join(", ")} if patient_form.errors.any?
        patient_form.save

        # store purposes(uses) of patient form
        purpose_ids = json_parse params[:purpose_ids]
        purpose_ids.each do |id|
          patient_form.patient_form_uses.create!(use_id: id) if Use.exists?(id)
        end
        return {status: true, message: "Patient Form saved successfully", patient_form_id: patient_form.id}
      end
    rescue Exception => e
      ErrorLogger.log("\n\n #{Time.now}\n Error While Creating Patient Form: \n Parameters passed are: #{params} \n\n Error Message: #{e.message}")
      return {status: false, message: e.message.gsub('Validation failed: ', '')}
    end
  end

  def self.save_images params
    response, message = params_present?({profile_image: [], sign_image: [], user_id: [], patient_form_id: []}, params)
    return {status: false, message: message} unless response
    patient_form = PatientForm.find_by_id(params[:patient_form_id])
    return {status: false, message: "Patient Form Not Found"} if patient_form.nil?
    patient_form.profile_image, profile_image_filename = self.create_temp_file params[:profile_image]
    patient_form.sign_image, sign_image_filename = self.create_temp_file params[:sign_image]
    return {status: false, message: patient_form.errors.full_messages.join(", ")} if patient_form.errors.any?
    if patient_form.save
      File.delete(Rails.root.join('public', profile_image_filename))
      File.delete(Rails.root.join('public', sign_image_filename))
    end
    {status: true, message: "Patient Form images saved successfully."}
  end

  def self.create_temp_file image_encoded_data
    tmp_name = [*('A'..'Z'), *(0..9), *('a'..'z')].sample(16).join + ".jpg"
    File.open(Rails.root.join('public', tmp_name), 'wb') do |f|
      f.write(Base64.decode64(image_encoded_data.gsub(/\n/, '')))
    end
    return File.open(Rails.root.join('public', tmp_name)), tmp_name
  end

  def self.get_patient_details  params
    response, message = params_present?({patient: []}, params)
    return {status: false, message: message} unless response
    patient_params = json_parse params['patient']
    response, message = params_present?({id: []}, patient_params)
    return {status: false, message: message} unless response
    patient = Patient.select("id, first_name, last_name, email, phone_no, birth_date").find_by_id(patient_params[:id])
    return {status: false, message: "Patient not found"} if patient.nil?
    details = PatientForm.select("patient_forms.id, notes, follow_up_requested, profile_image, expiry_date, guardian_first_name, guardian_last_name, name, event_date, first_name, last_name").joins(:event, :user).where("patient_id = ? && is_revoked = ?", patient_params[:id], false)
    return {status: false, message: "Patient Form not found"} if details.nil?
    {status: true, patient: patient, form_details: details}
  end

  def self.get_patient_info_by_email params
    response, message = params_present?({patient: [], event_id:[]}, params)
    return {status: false, message: message} unless response
    patient_params = json_parse params['patient']
    response, message = params_present?({email: []}, patient_params)
    return {status: false, message: message} unless response


    # join approch #checkout for multiple patients one is registered and another is not to event
    # patients = Patient.joins('INNER JOIN patient_forms ON patients.id = patient_forms.patient_id').
    #                   where(:email => patient_params[:email]).
    #                   select('patients.id, email,first_name, last_name, birth_date, phone_no, event_id, notes')
    # return {status: false, message: "Patient not found"} if patients.empty?

    # response_patients = []
    # patients.each do |patient|
    #   response_patient = {
    #     id: patient.id,
    #     email: patient.email,
    #     first_name: patient.first_name,
    #     last_name: patient.last_name,
    #     birth_date: patient.birth_date,
    #     phone_no: patient.phone_no,
    #     notes: patient.event_id == params[:event_id].to_i && patient.notes.present? ? patient.notes : "",
    #     is_registered: patient.event_id == params[:event_id].to_i
    #   }
    #   response_patients << response_patient
    # end

    # { status: true,
    #   patients: response_patients
    # }

    # egar loading #quite more processing time
    patients = Patient.includes(:patient_forms).find_all_by_email(patient_params[:email])
    return {status: false, message: "Patient not found"} if patients.empty?

    response_patients = []
    event_requested = params[:event_id].to_i
    patients.each do |patient|
    patient_form = patient.patient_forms.
                          select{|pf| pf.event_id == event_requested }

      response_patient = {
        id: patient.id,
        email: patient.email,
        first_name: patient.first_name,
        last_name: patient.last_name,
        birth_date: patient.birth_date,
        phone_no: patient.phone_no,
        notes: patient_form.present? ? patient_form.first.notes : "",
        is_registered: patient_form.present?
      }

      response_patients << response_patient
    end

    { status: true,
      patients: response_patients
    }
  end

  def self.email_release_form params
    response, message = params_present?({user_id: [], patient_form_id: [], email: []}, params)
    return {status: false, message: message} unless response
    patient_form = PatientForm.find_by_id(params[:patient_form_id])
    return {status: false, message: "Patient Form not found"} if patient_form.nil?
    UserMailer.delay.release_form_mail(patient_form, params[:email])
    {status: true, message: "Email sent"}
  end

  def valid_follow_up_field
    errors.add(:follow_up_requested, "must be a boolean value") unless [true, false].include?(follow_up_requested)
  end

  def valid_expiry_date
    errors.add(:expiry_date, "is invalid") if expiry_date.present? && expiry_date < Date.today
  end

  def valid_event_id
    errors.add(:event_id, "is invalid") unless Event.exists?(event_id)
  end

  def valid_release_id
    errors.add(:release_id, "is invalid") unless Release.exists?(release_id)
  end

  def display_guardian_name
    self.guardian_first_name + " " + self.guardian_last_name
  end
end