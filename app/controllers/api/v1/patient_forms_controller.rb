class Api::V1::PatientFormsController < ApiController
  skip_before_filter :check_request ,  :only => [:save_images]
  respond_to :json

  def create
    response = PatientForm.create_form(params)
    render json: response.to_json
  end

  def save_images
    response = PatientForm.save_images(params)
    render json: response.to_json
  end

  def patient_details
    response = PatientForm.get_patient_details(params)
    render json: response.to_json
  end

  def patient_info
    response = PatientForm.get_patient_info_by_email(params)
    render json: response.to_json
  end

  def email_release_form
    response = PatientForm.email_release_form(params)
    render json: response.to_json
  end
end
