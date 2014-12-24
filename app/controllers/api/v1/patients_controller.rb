class Api::V1::PatientsController < ApiController
  respond_to :json

  def search
    response = Patient.search_release(params)
    render json: response.to_json
  end
end