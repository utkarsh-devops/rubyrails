class ReleaseForm < AbstractController::Base
  include AbstractController::Rendering
  include AbstractController::Helpers
  include AbstractController::Translation
  include AbstractController::AssetPaths
  include Rails.application.routes.url_helpers
  helper ApplicationHelper
  self.view_paths = "app/views"
  attr_reader :html
  def initialize(patient_form, uses, profile_image, sign_image)
    @patient_form = patient_form
    @uses = uses
    @profile_image = profile_image
    @sign_image = sign_image
    @html = render_to_string(partial: "shared/release_form", :layout => false,
                             :disposition => 'inline')
  end
  def pdf
    kit = PDFKit.new(@html)
    kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/pdf.css"
    kit.to_pdf
  end
end