class Patient < ActiveRecord::Base
  has_many :patient_forms
  has_many :events, :through => :patient_forms

  extend ApiHelper

  attr_accessible :birth_date, :email, :first_name, :last_name, :phone_no

  # Validations
  validates :first_name, :last_name, :email, :birth_date, presence: true

  # record will be unique on  first_name, last_name and birth_date
  validates_uniqueness_of :first_name,    :scope => [:birth_date, :last_name], :case_sensitive => false
  validates_format_of :email, :with => (/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i)
  validates_format_of :phone_no, :with => (/^\d{,15}$/), :allow_nil => true

  validate :valid_birth_date

  def valid_birth_date
    errors.add(:birth_date, "is invalid") if birth_date > Date.today
  end

  def display_name
    self.first_name + " " + self.last_name
  end

  def self.search_release params
    response, message = params_present?({query: []}, params)
    return {status: false, message: message} unless response
    patients = Patient.select("patients.id, first_name, last_name").
                      joins(:patient_forms).
                      where("first_name LIKE ? OR last_name LIKE ? AND is_revoked = ?","%#{params[:query]}%", "%#{params[:query]}%", false).
                      group("patients.id")
    patients.blank? ? {status: false, message: "No record found"} : {status: true, patients: patients}
  end
end
