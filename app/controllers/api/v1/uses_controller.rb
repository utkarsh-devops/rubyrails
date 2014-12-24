class Api::V1::UsesController < ApiController
  respond_to :json

  def index
    uses = Use.not_deleted.select("id, description")
    render json: {uses: uses}.to_json
  end
end