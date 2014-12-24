class Api::V1::EventsController < ApiController
  respond_to :json

  def create
    response = Event.create_event(params)
    render json: response.to_json
  end

  def get_upcoming_events
    offset = params.has_key?(:page) && params[:page].to_i > 1 ? (params[:page].to_i - 1) * 10 : 0
    upcoming_events = Event.select("id, name, event_date, is_permanent_event, user_id").where('is_permanent_event = ? && event_date >= ? ', false, Date.today).order("event_date, event_time ASC").limit(10).offset(offset)
    render json: {upcoming_events: upcoming_events}.to_json
  end

  def get_permanent_events
    offset = params.has_key?(:page) && params[:page].to_i > 1 ? (params[:page].to_i - 1) * 10 : 0
    permanent_events = Event.select("id, name, is_permanent_event, user_id").where('is_permanent_event = ? ', true).order("created_at DESC").limit(10).offset(offset)
    render json: {permanent_events: permanent_events}.to_json
  end
end
