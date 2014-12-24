class PatientFormUse < ActiveRecord::Base
  belongs_to :patient_form
  belongs_to :use

  attr_accessible :use_id
  # Validations
  validates :patient_form_id, :use_id, presence: true

  validates :patient_form_id, :uniqueness => {:scope => :use_id}
end
