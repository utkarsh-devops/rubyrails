class Api::V1::ReleasesController < ApiController
  skip_before_filter :check_request
  skip_before_filter :authentic_user

  def show_release
    @release = Release.last

    respond_to do |format|
      format.html
      format.js
    end
  end
end